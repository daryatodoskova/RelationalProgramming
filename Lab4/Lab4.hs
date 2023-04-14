--- Programming in untyped lambda calculus

-- Encodings of booleans and natural numbers from class
{-
true = \x.\y.x
false = \x.\y.y
not = \b.\x.\y.b y x
and = \b.\c.b c false
zero = \f.\x.x
one = \f.\x.f x
two = \f.\x.f (f x)
succ = \n.\f.\x.f (n f x)
add = \m.\n.m succ n
mult = \m.\n.m (add n) 0
isZero = \n.n (\b.false) true
-}

-- Exercise 1a
{-
isEven = \n.n not true 
-}

-- Exercise 1b
{-
exp = \mn.n (mult n) one
-}

-- Encodings of pairing and projections
{-
pair = \x.\y.\f.f x y
fst = \p.p (\x.\y.x)
snd = \p.p (\x.\y.y)
-}

-- Exercise 1c
{-
swap = \p. pair (snd p) (first p)
-}

-- Exercise 1d
{-
swapIf = \t.\p.t swap p
-}

-- Exercise 1e (optional)
{-
fib = <your definition here>
-}

-- Exercise 1e (optional)
{-
pred = <your definition here>
-}

-- Curry's and Turing's fixed point operators
{-
Y = \x.(\y.x(y y))(\y.x (y y))
Theta = (\x.\y.y (x x y)) (\x.\y.y (x x y))
-}

-- Exercise 1f (optional)
{-
collatz = <your definition here>
-}

--- STLC and type inference

-- Exercise 2a
{-
e1 :: \f x -> f x :: (a -> b) -> a -> b
e2 :: \f x -> f (f x) :: (a -> a) -> a -> a
e3 :: \x -> x (\y -> y) :: ((p -> p) -> a) -> a
e4 :: ??
e5 :: The expression cannot be reduced to a simple type
e6 :: ??
-}


-- Exercise 2b
fn1 :: a -> b -> (a -> b -> c) -> c
fn1 a b f = f a b 
fn2 :: a -> b -> (a -> b -> c) -> (a,b,c)
fn2 a b f = (a,b,f a b)
fn3 :: ([a] -> b) -> a -> b
fn3 f a = f [a]
--fn4 :: ((a -> a) -> b) -> b
--fn4 = f id 

-- Exercise 2c (optional)
{-
mysterylam = ??
-}


-- Exercise 2d (optional)
mysteryfn = undefined

--- Bidirectional typing

data Ty = TV Int | Fn Ty Ty
    deriving (Show,Eq)

data Expr = V Int | A Expr Expr | L Int Expr | Ann Expr Ty
    deriving (Show,Eq)

bcomp = L 0 $ L 1 $ L 2 $ A (V 0) (A (V 1) (V 2))

oneid = A (Ann (L 0 $ L 1 $ A (V 0) (V 1)) (Fn (Fn (TV 0) (TV 0)) (Fn (TV 0) (TV 0)))) (L 0 $ V 0)

type TyCxt = [(Int,Ty)]

-- Disclaimer, I was helped by Mark Daychman for the last exercise 
check :: TyCxt -> Expr -> Ty -> Bool
check context (V e) t = case lookup e context of 
    Just t_ -> t == t_
    Nothing -> False 
check context (A e1 e2) t = case synth context e1 of 
    Just (Fn t1 t2) -> check context e2 t1 && t == t2
    b -> False 
check context (Ann e t_) t = check context e t_ && t == t_
check context (L a e) (Fn t1 t2) = check ((a, t1):context) e t2
check context (L x e) _ = False 

synth :: TyCxt -> Expr -> Maybe Ty
synth context (V x) = lookup x context 
synth context (A e1 e2 ) = case synth context e1 of 
    Just (Fn t1 t2) -> if check context e2 t1 then Just t2 else Nothing 
    b -> Nothing
synth context (Ann e t) = if check context e t then Just t else Nothing 
synth context (L x e) = case synth ((x,TV 0):context) e of 
    Just t -> Just (Fn (TV 0) t)
    Nothing -> Nothing  


--Check 
-- First case is when the expression is a variable, then we check if the type is in the context given
-- Second case is when the expression is an application, then we check if the type of the left operand is a function, 
-- and if the the right one is of the input of the function
-- Third case is when the expression is annotated, then we check that it has the same type as the annotation
-- Fourth case is when the expression is lambda, then we check if the type is the output of the function
-- Else: the expression must not be typed correctly, so we return false 

--Synth 
-- First case is when the expression is a variable, then we return its type
-- Second case is when the expression is an application, it is analogue to check
-- Third case is when the expression is annotated, it is analogue to check
-- Fourth case is when the expression is lambda, it is analogue to check
