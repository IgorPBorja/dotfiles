\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{university}[Class for university assignments]
\LoadClass{article}

\RequirePackage{blindtext} %% dummy text
\RequirePackage{ragged2e} %% better text alignment
%% with Center, FlushLeft, FlushRight envs
\RequirePackage{amsmath, amsthm, amssymb, amsfonts}
\RequirePackage{geometry}
\geometry{margin=1cm}
\RequirePackage{changepage} % adjustwidth
\RequirePackage{url}

\newtheorem{problem}{Problema}
\newtheorem{lemma}{Lema}
\newtheorem{definition}{Definição}
\newtheorem{theorem}{Teorema}
\newtheorem{corollary}{Corolário}
\newtheorem{claim}{Afirmação}[theorem] %% restart count at each theorem
\newtheorem{example}{Exemplo}
\newtheorem{note}{Observação}

\newtheorem{problem*}{Problema}
\newtheorem{lemma*}{Lema}
\newtheorem{definition*}{Definição}
\newtheorem{theorem*}{Teorema}
\newtheorem{corollary*}{Corolário}
\newtheorem{claim*}{Afirmação} %% restart count at each theorem
\newtheorem{example*}{Exemplo}
\newtheorem{note*}{Observação}

%% ALWAYS load cleveref after hyperref
\RequirePackage{physics}
\RequirePackage{hyperref}
\RequirePackage{cleveref}
\crefname{problem}{Problema}{Problemas}
\crefname{lemma}{Lema}{Lemas}
\crefname{definition}{Definição}{Definições}
\crefname{theorem}{Teorema}{Teoremas}
\crefname{corollary}{Corolário}{Corolários}
\crefname{claim}{Afirmação}{Afirmações}
\crefname{example}{Exemplo}{Exemplos}
\crefname{note}{Observação}{Observações}

\renewcommand{\phi}{\varphi}
\renewcommand{\epsilon}{\varepsilon}

%% See https://tex.stackexchange.com/questions/196238/newenvironment-does-not-work
%% https://tex.stackexchange.com/questions/120013/multiline-equation-without-number
\newenvironment{grammar}[1]
{
  \align \nonumber #1:\quad
}
{
  \nonumber \endalign
}
\newcommand{\grule}[2]{\nonumber &#1 \to #2\\}
\newcommand{\derives}{\overset{*}{\Rightarrow}}
\newcommand{\wordto}{\Rightarrow}
%% https://tex.stackexchange.com/questions/74353/what-commands-are-there-for-horizontal-spacing
\renewcommand{\o}{\medspace | \medspace}

\newcommand{\B}{\mathcal{B}}
\newcommand{\N}{\mathbb{N}}
\newcommand{\Z}{\mathbb{Z}}
\newcommand{\Q}{\mathbb{Q}}
\renewcommand{\P}{\mathbb{P}}
\newcommand{\R}{\mathbb{R}}
\newcommand{\C}{\mathbb{C}}
\newcommand{\K}{\mathbb{K}}
\newcommand{\closure}[1]{\overline{#1}}
\newcommand{\pset}[1]{\mathcal{P}(#1)}
\renewcommand{\phi}{\varphi}
\renewcommand{\epsilon}{\varepsilon}
\DeclareMathOperator{\orb}{orb}
\DeclareMathOperator{\SF}{SF}
\DeclareMathOperator{\diam}{diam}
% Formal logic
\DeclareMathOperator{\sub}{sub}
\DeclareMathOperator{\Fm}{Fm}
\DeclareMathOperator{\Mod}{Mod}
%% in case \var was already defined as a delta
%% (see https://tex.stackexchange.com/questions/175251/how-to-redefine-a-command-using-declaremathoperator)
\let\var\relax
\DeclareMathOperator{\var}{var}
\DeclareMathOperator{\mdc}{mdc}
\DeclareMathOperator{\mmc}{mmc}

\newenvironment{solution}{
  \begin{adjustwidth}{1em}{0em}
  \begin{proof}[Solução]~
  }{
  \end{proof}
  \end{adjustwidth}
  }

%% Tikz configuration options
\RequirePackage{tikz}
\usetikzlibrary{automata, positioning, arrows}
%% STYLING
%% accepting node
\tikzstyle{accepting}=[double distance=2pt, outer sep=1pt+\pgflinewidth]
%% Initial arrow
\tikzset{
  initial text=,
  %% initial arrow length = 1cm
  initial distance=1cm
}
%% Node distances and edge styles
\tikzset{
  node distance=2cm,
  ->, ultra thick,
  %% 3pt space from the tip of the arrow to the destination node
  shorten > = 3pt,
  %% 3pt space from the origin node to the start of the arrow
  shorten < = 3pt,
}
\newenvironment{tikzhere}{
  \begin{figure}[H]
    \centering
    \begin{tikzpicture}[thick]
}{
    \end{tikzpicture}
  \end{figure}
}

\newcommand{\n}[1][]{\node[state, #1]}
\newcommand{\init}[1][]{\node[state, initial, #1]}
%%\renewcommand{\a}[2][0.05cm]{node[above=#1]\{#2\}}
%%\renewcommand{\b}[2][0.05cm]{node[below=#1]\{#2\}}
%%\renewcommand{\l}[2][0.05cm]{node[left=#1]\{#2\}}
%%\renewcommand{\r}[2][0.05cm]{node[right=#1]\{#2\}}


\RequirePackage{float}
\RequirePackage{pgffor}
\RequirePackage[nomessages]{fp}
\RequirePackage{enumitem}


\newcommand{\sepline}{
  %% \rule[h]{w}{t}
  % h = the height above the baseline to which raise the box (defaults at 0)
  % w = the width of the box
  % t = the thickness of the rule
  \par\noindent\rule[0pt]{0.8\textwidth}{0.4pt}
}

\newcommand{\uniHeadline}[4]{
  %% vspace* garantees that the space will not be deleted if it is at the start of page
  \vspace*{0.2em}
  \begin{Center}
    \MakeUppercase{#1}
    \sepline
    \vspace{0.5em}
  \end{Center}
  \par
  \begin{FlushRight}
    \setlength{\hsize}{0.9\hsize}
    \hspace*{-0.5\textwidth}
    \large Aluno: #2
    \par
    %% \hspace*{0.1\textwidth}
    \large Disciplina: #3
    \par
    \large Professor: #4
  \end{FlushRight}
  \par
}

%% makes title without inserting the new page
%% (inserting is the default)
%% by making newpage a no-op in this context
\newcommand{\maketitleNobreak}{
  %% https://tex.stackexchange.com/questions/86249/maketitle-text-before-title
  {\let\newpage\relax\maketitle}
}

\newcommand{\ufbaHeadline}[2]{
  \uniHeadline{Universidade Federal da Bahia}{Igor Prado Teixeira Borja}{#1}{#2}
  \maketitleNobreak
}

\newcommand{\nodate}{
  %% blank date and remove the vertical space
  %% it should occupy (5ex)
  \date{\vspace*{-5ex}}
}
