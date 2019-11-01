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

\subsubsection{User-defined definitional equality}

User-defined definitional equality in Agda~\cite{RewriteWithoutK},
which can be enabled via the flag \texttt{--rewriting},
is used along with axiomatic path constructors in Agda.
Here's the
\href{https://github.com/HoTT/HoTT-Agda/blob/4943024aaeb766be911a8bd97dde363759dc8928/core/lib/types/SetQuotient.agda}
{definition} of quotient type, \AgdaDatatype{SetQuot},
in the HoTT-Agda library~\cite{AgdaHoTT}:

% To work with custom definitional equalities,
% we need to specify a binary type constructor for rewriting:

\begin{code}[hide]
postulate _↦_ : ∀ {i} {A : Type i} → A → A → Type i
{-# BUILTIN REWRITE _↦_ #-}
\end{code}
\begin{code}[hide]
module _ {i} {A : Type i} {j} where

 Rel : ∀ (A : Type i) j → Type (lmax i (lsucc j))
 Rel A j = A → A → Type j
\end{code}
\begin{code}[hide]
 postulate SetQuot : (R : Rel A j) → Type (lmax i j)
 postulate R : Rel A j
\end{code}
\begin{code}
 postulate  -- HIT
  q[_] : (a : A) → SetQuot R
  quot-rel : {a₁ a₂ : A} → R a₁ a₂ → q[ a₁ ] ≡ q[ a₂ ]
\end{code}
\begin{code}[hide]
    -- instance SetQuot-is-set : is-set (SetQuot R)

 module SetQuotElim {k} {P : SetQuot R → Type k} (q[_]* : (a : A) → P q[ a ]) where
  --   {{p : {x : SetQuot R} → is-set (P x)}} (q[_]* : (a : A) → P q[ a ])
  --   (rel* : ∀ {a₁ a₂} (r : R a₁ a₂) → q[ a₁ ]* ≡ q[ a₂ ]* [ P ↓ quot-rel r ]) where
  postulate    f : Π (SetQuot R) P
\end{code}

We define a custom rewriting rule to make the
quotient type's equivalent class definitional,
based on the \AgdaFunction{quot-rel} relation:

\begin{code}
  postulate q[_]-β : (a : A) → f q[ a ] ↦ q[ a ]*
  {-# REWRITE q[_]-β #-}
\end{code}

