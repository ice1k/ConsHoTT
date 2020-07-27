\begin{code}[hide]
{-# OPTIONS --cubical #-}
open import Cubical.Core.Everything
open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
open import Cubical.Data.Prod
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
so we can put them together and form a new language structure,
which is our path constructors.
Example $\mathbb Z$ defined by this idea, in Cubical Agda:

\begin{code}[number]
data ℤ : Set where
  pos  : ℕ → ℤ
  neg  : ℕ → ℤ
  zro  : pos 0 ≡ neg 0
\end{code}

The last constructor, \AgdaInductiveConstructor{zro}, is the path constructor.
It's a path, because it has a path type,
while it's still a constructor, because it can be applied to an interval
and return an instance of $ℕ$.
In other words,

\begin{code}[number]
zro' : I → ℤ
zro' i = zro i
\end{code}

While \AgdaInductiveConstructor{pos} and \AgdaInductiveConstructor{neg}
are point constructors.
Note that path constructors have the special reduction rules of paths
that point constructors don't have,
as claimed in~\ref{eqn:path-app}.

Similar to \textit{conditions} introduced in~\cref{subsec:conditions},
path constructors will add constraints on the operations defined for
the HIT.
However, the syntax is different -- the path constructors should be
a part of the pattern matching
(while conditions only play as extra constraints).
As an example, here's the \AgdaFunction{absolute-value}
function for the $\mathbb Z$ type:

\begin{code}[number]
absolute-value : ℤ → ℕ
absolute-value (pos x)  = x
absolute-value (neg x)  = x
absolute-value (zro i)  = 0
\end{code}

The constraint added by \AgdaInductiveConstructor{zro} is that the path
$p=\textsf{ap}_{\AgdaFunction{absolute-value}}(\AgdaInductiveConstructor{zro})$
should satisfy that $p~\textsf 0 ≡ \AgdaFunction{absolute-value}
(\AgdaInductiveConstructor{zro}~\textsf 0)$ and
$p~\textsf 1 ≡ \AgdaFunction{absolute-value}
(\AgdaInductiveConstructor{zro}~\textsf 1)$.
In some sense, we can see the pattern matching clause for \AgdaInductiveConstructor{zro}
as a \textit{propositional proof} (while for conditions it has to be definitional)
that \AgdaFunction{absolute-value} respects \AgdaInductiveConstructor{zro}.

We may reproduce the \textsf{absolute-value-cheat} in~\cref{subsec:conditions}:

\begin{code}[number]
absolute-value-cheat : ℤ → ℕ
absolute-value-cheat (pos x)  = suc x
absolute-value-cheat (neg x)  = suc x
absolute-value-cheat (zro i)  = 1
\end{code}

% There are some other HITs where conditions cannot define but path constructors can,
% are the ones with path constructors independent on

Some very interesting HITs such as the $\mathbb{S}^1$ type,
can only be defined via path constructors (instead of conditions):

\begin{code}[number]
data S¹ : Set where
  base  : S¹
  loop  : base ≡ base
\end{code}

This $\mathbb{S}^1$ may not look so interesting itself,
but there's already one thing we can prove about it
(another interesting thing is that it's isomorphic to the integer type,
but the proof will be easier with univalence so we discuss this later in~\cref{sec:ua}),
that is the cartesian product of two $\mathbb{S}^1$ is isomorphic to a torus $T^2$
(section 6.6 in the HoTT Book):
-- A torus has a base \textsf{point}, two distinct paths (called \textsf{line1} and \textsf{line2})
-- connecting the base point to itself, and a homotopy (called \textsf{square}) between the lines.

\begin{code}[number]
data T² : Set where
  point   : T²
  line1   : point ≡ point
  line2   : point ≡ point
  square  : PathP (λ i → line1 i ≡ line1 i) line2 line2
\end{code}

Note that \AgdaFunction{PathP} is the type for heterogeneous
paths (recall~\ref{eqn:hetero-path}) in Cubical Agda,
where the first parameter is the type family indexed by $\mathbb I$,
the rest two are the endpoints.
By this definition, the definitional equalities we get are not only:

\[
  \AgdaInductiveConstructor{square i0} \equiv \AgdaInductiveConstructor{line2}
  \xtag
  \quad
  \AgdaInductiveConstructor{square i1} \equiv \AgdaInductiveConstructor{line2}
  \xtag
\]

But also:

\[
  (λ i~→~\AgdaInductiveConstructor{square } i \AgdaInductiveConstructor{ i0})
    \equiv \AgdaInductiveConstructor{line1}
  \xtag
\]
\[
  (λ i~→~\AgdaInductiveConstructor{square } i \AgdaInductiveConstructor{ i1})
    \equiv \AgdaInductiveConstructor{line1}
  \xtag
\]

We may interpret \AgdaInductiveConstructor{square}
as the filler (recall~\cref{subsec:fill}) of the following square:
% where $i$ goes from left to right and $j$ is from bottom to top:

\begin{center}
\begin{tikzpicture}[node distance=1.5cm]
\node(1) {\AgdaInductiveConstructor{point}};
\node(2) [right=4cm of 1] {\AgdaInductiveConstructor{point}};
\node(4) [below of=1] {\AgdaInductiveConstructor{point}};
\node(3) [below of=2] {\AgdaInductiveConstructor{point}};
\draw (1) -- (2) node[midway,above] {\AgdaInductiveConstructor{line1}};
\draw (1) -- (4) node[midway,left]  {\AgdaInductiveConstructor{line2}};
\draw (3) -- (2) node[midway,right] {\AgdaInductiveConstructor{line2}};
\draw (3) -- (4) node[midway,below] {\AgdaInductiveConstructor{line1}};
\end{tikzpicture}
\end{center}
% \caption{Square filled by \AgdaInductiveConstructor{square}}
% \label{fig:square-tikz}
% \end{figure}

The conversion functions are so natural:

\begin{code}[number]
t2c : T² → S¹ × S¹
t2c point         = base , base
t2c (line1 i)     = loop i , base
t2c (line2 j)     = base , loop j
t2c (square i j)  = loop i , loop j

c2t : S¹ × S¹ → T²
c2t (base   , base)    = point
c2t (loop i , base)    = line1 i
c2t (base   , loop j)  = line2 j
c2t (loop i , loop j)  = square i j
\end{code}

The proof that \AgdaFunction{t2c} and \AgdaFunction{c2t} are inverse
is even simpler -- all the clauses are just \AgdaFunction{refl}:

\begin{code}[number]
c2t-t2c :  (t : T²) → c2t (t2c t) ≡ t
c2t-t2c point         = refl
c2t-t2c (line1 _)     = refl
c2t-t2c (line2 _)     = refl
c2t-t2c (square _ _)  = refl

t2c-c2t :  (p : S¹ × S¹) → t2c (c2t p) ≡ p
t2c-c2t (base   , base)    = refl
t2c-c2t (base   , loop _)  = refl
t2c-c2t (loop _ , base)    = refl
t2c-c2t (loop _ , loop _)  = refl
\end{code}

We cannot define HITs like $\mathbb{S}^1$ or $T^2$ via conditions,
because none of these path constructors -- \AgdaInductiveConstructor{loop},
\AgdaInductiveConstructor{line1}, \AgdaInductiveConstructor{line2}
and \AgdaInductiveConstructor{square} can be expressed as
``when the argument of some constructor is something,
the term constructed by this constructor is definitionally
equivalent to something else'',
as they have nothing to do with any \textit{parameters} of any constructors.

