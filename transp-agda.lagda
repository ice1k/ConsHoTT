\begin{code}[hide]
{-# OPTIONS --cubical #-}
open import Cubical.Core.Everything
open import Cubical.Foundations.Prelude hiding (J)
variable A : Set
variable a b c d : A
\end{code}

A definition similar to \textsf{coe} in Cubical Agda (as well as in CTT) is \AgdaFunction{transp}.
We can prove the \textbf J rule as a theorem with it:

\begin{minted}{arend-lexer.py:ArendLexer -x}
  \func J {A : \Type} {a : A} (B : \Pi (a' : A) -> a = a' -> \Type)
          (b : B a idp) {a' : A} (p : a = a') : B a' p =>
          coe (\lam i => B (p @ i) (psqueeze p i)) b right
\end{minted}

We can also do this in Agda:

\begin{code}[hide]
module _ (P : ∀ b → a ≡ b → Set) (d : P a refl) where
\end{code}
\begin{code}[number]
 J : (p : a ≡ b) → P b p
 J p = transp (λ i → P (p i) (λ j → p (i ∧ j))) i0 d
\end{code}

However, Arend supports an alternative syntax for invoking \textbf J -- that is
dependent pattern matching on \textsf{idp}, which is similar to dependent pattern matching
in MLTT's identity type. So, we can prove everything we'd like to prove with \textbf J by
pattern matching, such as path symmetry:

\begin{minted}{arend-lexer.py:ArendLexer -x}
\func inv {A : \Type} {a a' : A} (p : a = a') : a' = a \elim p
  | idp => idp
\end{minted}

