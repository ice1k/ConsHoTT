\begin{code}[hide]
{-# OPTIONS --cubical #-}
open import Cubical.Core.Everything
open import Cubical.Foundations.Prelude
variable A : Set
variable a b c d : A
\end{code}

The composition in~\cref{fig:simple-comp} looks like the following in
Cubical Agda:

\begin{code}[hide]
\end{code}
\begin{code}[number]
compose : c ≡ a → d ≡ b → c ≡ d → a ≡ b
compose p q r i = hcomp (λ j → λ
  {  (i = i0)  → p j
  ;  (i = i1)  → q j
  }) (r i)
\end{code}

Here's the proofs of \AgdaFunction{symm} and \AgdaFunction{trans},
as promised in~\cref{subsec:coe}:

\begin{code}[number]
symm : a ≡ b → b ≡ a
symm p = compose p refl refl

trans : a ≡ b → b ≡ c → a ≡ c
trans p q = compose (symm p) refl q
\end{code}

We prove both them as corollaries of \AgdaFunction{compose}.
