\begin{code}[hide]
{-# OPTIONS --rewriting #-}

-- Code ported from HoTT-Agda

open import Agda.Primitive public using (lzero)
  renaming (Level to ULevel; lsuc to lsucc; _⊔_ to lmax)

Type : (i : ULevel) → Set (lsucc i)
Type i = Set i

infix 30 _≡_
data _≡_ {i} {A : Type i} (a : A) : A → Type i where
  idp : a ≡ a

Π : ∀ {i j} (A : Type i) (P : A → Type j) → Type (lmax i j)
Π A P = (x : A) → P x

infix 30 _↦_
\end{code}

\subsubsection{Rewritings}

User-defined definitional equality in Agda~\cite{RewriteWithoutK},
which can be enabled via the flag \texttt{--rewriting},
is used along with axiomatic path constructors in Agda.
To enable this,
we need to specify the rewriting type:

\begin{code}
postulate _↦_ : ∀ {i} {A : Type i} → A → A → Type i
{-# BUILTIN REWRITE _↦_ #-}
\end{code}

After this, we can use the \AgdaKeyword{REWRITE} pragma
with an expression of type {$a_1$ \AgdaFunction{↦} $a_2$} provided
to let Agda rewrite $a_1$ into $a_2$ as much as possible.
This feature can easily make Agda infinite loop,
so it's considered unsafe.

Here's the
\href{https://github.com/HoTT/HoTT-Agda/blob/4943024aaeb766be911a8bd97dde363759dc8928/core/lib/types/SetQuotient.agda}
{definition} of quotient type, \AgdaDatatype{SetQuot},
in the HoTT-Agda library~\cite{AgdaHoTT}
(there is \AgdaFunction{SetQuot-is-set}, but omitted for simplicity):

\begin{code}[hide]
module _ {i} {A : Type i} {j} where

 Rel : ∀ (A : Type i) j → Type (lmax i (lsucc j))
 Rel A j = A → A → Type j
\end{code}
\begin{code}
 postulate SetQuot : (R : Rel A j) → Type (lmax i j)
\end{code}
\begin{code}[hide]
 postulate R : Rel A j
\end{code}
\begin{code}
 postulate  -- HIT
  q[_] : (a : A) → SetQuot R
  quot-rel : {a b : A} → R a b → q[ a ] ≡ q[ b ]
\end{code}
\begin{code}[hide]
    -- instance SetQuot-is-set : is-set (SetQuot R)

 module SetQuotElim {k} {P : SetQuot R → Type k} (q[_]* : (a : A) → P q[ a ]) where
  --   {{p : {x : SetQuot R} → is-set (P x)}} (q[_]* : (a : A) → P q[ a ])
  --   (rel* : ∀ {a b} (r : R a b) → q[ a ]* ≡ q[ b ]* [ P ↓ quot-rel r ]) where
\end{code}

We define a custom rewriting rule to make the
quotient type's equivalent class definitional,
based on the \AgdaFunction{quot-rel} relation:

\begin{code}
  postulate
   f : Π (SetQuot R) P
   q[_]-β : (a : A) → f q[ a ] ↦ q[ a ]*
  {-# REWRITE q[_]-β #-}
\end{code}

This \AgdaDatatype{SetQuot} definition still don't check if
the equivalent classes are really equivalent classes,
and if the functions respect the path constructors.
