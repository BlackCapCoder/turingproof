import Data.Bits

-- This is the language given in the lecture
data Op = STOP
        | LOAD
        | STORE
        | ADD
        | SUB
        | BRANCH
        | BRZERO
        | BRNEG
        | BROVFL
        | IN
        | OUT
        | NOP
        deriving Enum

-- Operations have 16 bits for parameters
stop     = (STOP,   0)
load   x = (LOAD,   x)
store  x = (STORE,  x)
add    x = (ADD,    x)
sub    x = (SUB,    x)
branch x = (BRANCH, x)
brzero x = (BRZERO, x)
brneg  x = (BRNEG,  x)
brovfl x = (BROVFL, x)
inp      = (IN,     0)
out      = (OUT,    0)
nop      = (NOP,    0)


-- Brainfuck without IO
data BF = Inc | Dec | Next | Prev | Loop [BF]

-- Iterated collatz
type Collatz = [(Integer, Integer, Integer)]

-- Convert a operation to binary
toBinary (op, adr) = adr + shiftL (fromEnum op) 12

-- Parse a brainfuck program
parse = fst . parse'
  where parse' []       = ([], [])
        parse' (']':xs) = ([], xs)
        parse' xs | Just (o, rst) <- parseOp xs = (\(a,b) -> (o:a, b)) $ parse' rst
                  | otherwise = parse' $ tail xs

        parseOp (x:xs)
          = case x of
              '+' -> Just (Inc , xs)
              '-' -> Just (Dec , xs)
              '>' -> Just (Next, xs)
              '<' -> Just (Prev, xs)
              '[' | (x,xs) <- parse' xs -> Just (Loop x, xs)
              _   -> Nothing

-- Convert iterated collatz to brainfuck
toBrainfuck :: Collatz -> [BF]
toBrainfuck l = parse $ ">>+[-" ++ foldr branch "++<<[->+<]" l ++ ">[-<+>]>]"
  where branch (a,b,c) s = concat
		  [ "[-<", a*="+", ">]", c*="+", '<' : b*="+"
          , "<[->", b*="-", '[' : a*="-", ">+<]>", c*="-"
          , s, "]" ]
        n*=l = [1..n]>>l

-- Convert brainfuck to lecture language
-- Note that this assumes that the loops are circular
-- which is guaranteed for the generated code, but
-- not for generic brainfuck programs.
convert _ _ [] = []
convert ptr loc (x:xs)
  = case x of
      Next    -> convert (ptr+1) loc xs
      Prev    -> convert (ptr-1) loc xs
      Inc     -> load ptr : add 1 : store ptr : convert ptr (loc+4) xs
      Dec     -> load ptr : sub 1 : store ptr : convert ptr (loc+4) xs
      Loop ops | q <- convert ptr (loc+3) ops
              -> load ptr : sub 0 : brzero (loc+length q+8)
               : q
              ++ load ptr : sub 0 : brzero 0
               : brzero loc : convert ptr (loc+length q+8) xs

-- Allocate 3 bytes at the beginning of the program to use as memory.
-- Amazingly this is turing-complete with only 3 bytes of memory; it will never use more
convert' p = branch 4 : replicate 3 stop ++ convert 1 4 p ++ [stop]
