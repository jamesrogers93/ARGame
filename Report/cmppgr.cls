% Latex Style for AVSP 2009.
%
% Revision 1.0
% Feb. 12 2009.
%
% Barry-John Theobald, University of East Anglia, Norwich, UK.

%------------------------------------------------------------------------------------------  
% Set up the article.

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{cmppgr}[2009/02/12  v1.0 CMP Research Day Proceedings class]

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions
\LoadClass[a4paper,10pt,twocolumn]{article}

\RequirePackage{times}

%------------------------------------------------------------------------------------------  
% Page Layout.

% Set up the margins for A4.
\setlength{\topmargin}{11mm}
\setlength{\headheight}{0mm}
\setlength{\headsep}{-1mm}

\oddsidemargin -10mm
\evensidemargin -10mm

\textheight 235mm
\textwidth 175mm

\footskip 0mm

\voffset -0.7mm

\columnsep 10mm

% Shrink the normal font size.
\renewcommand\normalsize{\small}

%------------------------------------------------------------------------------------------  
% Title, author and institution info.

\newcommand{\@name}{}
\newcommand\name[1]{\renewcommand{\@name}{\large\textit{#1\\[5mm]}}}

\newcommand{\@institution}{}
\newcommand\institution[1]{\renewcommand{\@institution}{\large\textup{#1}\par}}

\newcommand{\@email}{}
\newcommand\email[1]{\renewcommand{\@email}{\small{\texttt{#1\\[10mm]}}}}

\def\@maketitle{
	\newpage\vspace{5mm}
	{\centering{\Large\bfseries \@title\par}\vspace{5mm}{{\@name}}{ \@institution\@email}}
}
		
\renewcommand\maketitle{\par\twocolumn[\@maketitle]}

\newcommand\keywords[1]{{\noindent\textbf{Index Terms}: #1}}

\pagestyle{empty}

%------------------------------------------------------------------------------------------  
% Sections.
\renewenvironment{abstract}{\vspace*{-20pt}\section*{\abstractname}\normalsize}{}

\renewcommand{\section}{\@startsection{section}{1}{\z@}{-\baselineskip}{0.5\baselineskip}{\centering\large\bf}}
\renewcommand{\subsection}{\@startsection{subsection}{2} {\z@}{-\baselineskip} {0.5\baselineskip}{\normalsize\bf}}
\renewcommand{\subsubsection}{\@startsection{subsubsection}{3} {\z@}{-\baselineskip} {0.5\baselineskip}{\normalsize\it}}

%------------------------------------------------------------------------------------------  
% Environments.
\setlength\belowcaptionskip{0pt}
\def\fnum@figure{\small{\figurename~\thefigure}}
\def\fnum@table{\small{\tablename~\thetable}}

% Image source
\newcommand{\source}[1]{\caption*{Source: {#1}} }
