\begin{code}[hide]
{-# OPTIONS --cubical #-}
open import Cubical.Core.Everything
open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
variable A B : Set
\end{code}

\subsection{Paths as constructors}
\label{subsec:path-hit}

Here's the solution in CTT and CCTT.
Recall that a path on type $A$ are similar to
a function from $\mathbb I$ to $A$.
Constructors of type $A$ are similar to a function
from something arbitrary to $A$, but they don't reduce.
These two properties don't clash,
so we can put them together, form a new language structure.
Example $\mathbb Z$ defined by this idea:

\begin{code}
data ℤ : Set where
  pos : ℕ → ℤ
  neg : ℕ → ℤ
  zro : pos 0 ≡ neg 0
\end{code}

The last constructor, \AgdaInductiveConstructor{zro}, has a path type.
It's still a constructor, because it can be applied to an interval
and return an instance of $ℕ$.
In other words,

\begin{code}
zro' : I → ℤ
zro' i = zro i
\end{code}



\TODO
