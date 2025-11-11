\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{degi}[2025/10/06 Beispiel-Klasse]
% Erstellt von Del Zordo Gianmaria am 06.10.2025

\LoadClass[a4paper,12pt]{scrartcl} % KOMA-Script Artikelklasse

% Pakete
\RequirePackage[left=2cm, right=2cm, top=2.5cm, bottom=2.5cm]{geometry}
\RequirePackage[ngerman]{babel}
\RequirePackage{graphicx}
\RequirePackage[headsepline,footsepline]{scrlayer-scrpage}
\RequirePackage{lastpage}
\RequirePackage{etoolbox}
\RequirePackage[dvipsnames]{xcolor}
\RequirePackage[colorlinks=true, linkcolor=black, urlcolor=MidnightBlue]{hyperref}
\RequirePackage{float}
\RequirePackage{array}
\RequirePackage{enumitem}
\RequirePackage{amssymb}
\RequirePackage{listings}      % statt minted
\RequirePackage[ngerman]{babel}
\RequirePackage{amsmath}
\RequirePackage{cancel}
\RequirePackage{glossaries}
\RequirePackage{xparse}




% Tabellendefinierung test
\newcommand{\meinWindowsTabelle}{
  \begin{table}[H]
    \centering
    \begin{tabular}{|l|>{\raggedright\arraybackslash}m{6.8cm}|m{7cm}|}
      \hline
      \textbf{Begriff} & \textbf{Erklärung} & \textbf{Beispiel} \\
      \hline
      Schaum & Gasförmig Blächen in einer Flüssigkeit & Bierschaum/ Rasierschaum \\
      \hline
      Hartschaum. & Gasförmige Blächen in einem Festkörper 2 & Styropor/ Schwamm \\
      \hline
      Aerosol & \textbf{Rauch}: Fester Teilchen im Gas/ \textbf{Nebel}: Flüssiger Teilchen in einem Gas & Zigarettenrauch/ Nebel (von wasser dampf) \\
      \hline
      Suspension & Feste Teilchen in einer Flüssigkeit & Orangensaft/ Sandwasser\\
      \hline
      Emulsion & Gemisch mehrerer nicht mischbarer Flüssigkeiten & Milch/ Salatsause\\
      \hline
      Gemenge & Gemisch mererer nicht mischbarer Festkörper & Kies/ Müsli\\
      \hline
    \end{tabular}
    \caption{Heterogenes Gemisch}
    \label{table:Gemisch}
  \end{table}
}

%% ansprechen im .Tex mit \meinWindowsTabelle

% Mathe test
\newcommand{\Formeln}{
\begin{equation}
\overline{3x+5\underline{b-2}}
\end{equation}
\begin{eqnarray}
f(x) & = & \overbrace{2n+1\cdot x^{2}}^{n=1,2,3,4,5} \\
g(x) & = & \frac{2x^{\cancel{2}}-3\bcancel{x}}{\bcancel{x}}\\
     & = & 2x-3 \\
\\[1em]
&&\frac{\cancelto{5-2}{20-8x}}{\xcancel{4}x}
\end{eqnarray}
\begin{equation}
s(t) = s_0 + v_0 t + \frac{1}{2} a t^2
\end{equation}
\begin{equation}
\cancelto{6^3}{\sqrt[3]{6^9}} = 216
\end{equation}
\begin{equation}
E = m c^2
\end{equation}
\begin{equation}
\cancel{\frac{n}{0}} \quad \text{(Durch 0 wird nie geteilt)}
\end{equation}
}



% Listen mit Herz
\setlist[itemize,1]{label=\textcolor{Fuchsia}{\scriptsize$\heartsuit$}}



% Titel-Variablen
\newcommand{\mytitle}{}
\newcommand{\mysubtitle}{}
\newcommand{\myauthor}{}
\newcommand{\mydate}{\today}

% Kopf- und Fußzeilen
\clearpairofpagestyles
\ifoot*{\footnotesize \mysubtitle: \mytitle \quad \myauthor, \mydate}
\cfoot*{}
\ofoot*{\footnotesize \pagemark/\pageref{LastPage}}
\ohead{\includegraphics[height=1.2cm]{./Image/BFO_Logo.png}}

% Inhaltsverzeichnis mit Kopf-/Fußzeilen
\pretocmd{\tableofcontents}{\pagestyle{scrheadings}}{}{}
\apptocmd{\tableofcontents}{\thispagestyle{scrheadings}}{}{}

% Neues \maketitle
\renewcommand\maketitle{
  \pagenumbering{roman}
  \begin{titlepage}
    \begin{center}
      \vspace*{5cm}
      {\huge \bfseries \mytitle \par}
      \vspace{2ex}
      {\Large \bfseries \mysubtitle \par}
      \vspace*{5cm}
      \includegraphics[height=2cm]{./Image/BFO_Logo.png}\par
      \vspace{2ex}
      {\large \myauthor \par}
      {\large \mydate \par}
    \end{center}
  \end{titlepage}
  \thispagestyle{empty}
  
% Fußzeile für TOC anpassen: Keine Seitenzahl unten rechts.
  \ofoot*{}
  \pagestyle{scrheadings}
  \tableofcontents
  \clearpage
  
% Fußzeile wieder vollständig aktivieren mit Seitenzahl
  \ofoot*{\footnotesize \pagemark/\pageref{LastPage}}
  \pagenumbering{arabic}
  \setcounter{page}{1}
  \pagestyle{scrheadings}
}

% #00688f == Ado's Rose
\definecolor{MyColor}{HTML}{00688f}
\definecolor{MyPink}{HTML}{b484ea}
\definecolor{MyLinkColor}{HTML}{00688f}


% latex code block in der klasse
% titel ändern
\renewcommand\lstlistlistingname{Quellcodeverzeichnis}
\definecolor{codegreen}{rgb}{0,0.6,0} % Dunkel grün
\definecolor{codegray}{rgb}{0.5,0.5,0.5} % Mittelgrau
\definecolor{codepurple}{rgb}{0.58,0,0.82} % Lila/violett
\definecolor{backcolour}{rgb}{0.95,0.95,0.95}% Sehr helles Grau
\definecolor{bfored}{HTML}{D4000F} % Bfo rot



% arlauben won umlauten und co
\lstset{literate=
  {Ö}{{\"O}}1
  {Ä}{{\"A}}1
  {Ü}{{\"U}}1
  { ß }{{\ss}}2
  {ü}{{\"u}}1
  {ä}{{\"a}}1
  {ö}{{\"o}}1
}

% devinieren vom code
\lstdefinestyle{mysourcecode}{
  backgroundcolor=\color{backcolour},
  commentstyle=\color{codepurple},
  keywordstyle=\color{magenta},
  numberstyle=\tiny \color{codegray},
  stringstyle=\color{codepurple},
  basicstyle=\ttfamily \footnotesize,
  breakatwhitespace=false,
  breaklines=true,
  captionpos=b, % t=top, b=bottom
  keepspaces=true,
  numbers=left,
  numbersep=5pt,
  showspaces=false,
  showstringspaces=false,
  showtabs=false,
  tabsize=2,
  xleftmargin=0.8cm,
}

% Definiren von bash code eingabe
\lstdefinestyle{myTerminal}{
  basicstyle=\ttfamily \footnotesize \bfseries,
  breakatwhitespace=true,
  breaklines=true,
  keepspaces=true,
  numbers=none,
  showspaces=false,
  showstringspaces=false,
  showtabs=false,
  tabsize=2,
  xleftmargin=0.4cm,
}

% Definieren von bash code ausgabe
\lstdefinestyle{myTerminalOutput}{
  backgroundcolor=\color{backcolour},
  basicstyle=\ttfamily\footnotesize,
  breakatwhitespace=true,
  breaklines=true,
  keepspaces=true,
  numbers=none,
  showspaces=false,
  showstringspaces=false,
  showtabs=false,
  tabsize=2,
  xleftmargin=0.4cm,
}
% Latex code
\lstdefinestyle{myTex}{
  backgroundcolor=\color{backcolour},
  commentstyle=\color{codepurple}\ttfamily,
  keywordstyle=\color{codegreen}\ttfamily,
  basicstyle=\ttfamily\footnotesize,
  numbers=left,
  numberstyle=\tiny\color{codegray},
  numbersep=5pt,
  breaklines=true,
  inputencoding=utf8,
  extendedchars=true,
  literate=
    {\\}{{\textcolor{codegreen}{\textbackslash}}}1
    {\\\\}{{\textcolor{bfored}{\textbackslash\textbackslash}}}2
    {Ö}{{\"O}}1
    {Ä}{{\"A}}1
    {Ü}{{\"U}}1
    {ß}{{\ss}}1
    {ü}{{\"u}}1
    {ä}{{\"a}}1
    {ö}{{\"o}}1,
  morekeywords={usepackage,section,textbf, textit, hline, caption, label, overline, underline, frac, cdot, cancel, bcancel, xcancel, renewcommand,lstlistlistingname, definecolor, item, setlist, textcolor, scriptsize, lstset,begin,end,newcommand,Formeln,raggedright,arraybackslash,footnotesize,ttfamily, color,lstdefinestyle,bfseries,tiny,centering,includegraphics,maketitle,vspace,huge,mytitle, mysubtitle,myauthor,mydate,today,par,mysubtitle,thispagestyle,clearpairofpagestyles,ifoot, cfoot,ofoot,ohead,quad,pagemark,pageref,pretocmd,tableofcontents,pagestyle,apptocmd, tableofcontents,clearpage,pagenumbering,setcounter,newglossaryentry,NeedsTeXFormat,ProvidesClass,LoadClass,},
  morecomment=[l]{\%},
  showspaces=false,
  showstringspaces=false,
  showtabs=false,
  tabsize=2,
  keepspaces=true
}
