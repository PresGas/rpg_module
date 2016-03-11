%% module.cls
%
% An Adventure Module class for LaTeX
%
% Copyright 2016 Michael C. Davis
%
% LICENSE FOR THE WORK
%
% This work consists of the files module.cls and module.tex.
%
% This work may be distributed and/or modified under the conditions of the LaTeX
% Project Public License, either version 1.3 of this license or (at your option)
% any later version. The latest version of this license can be found at:
% http://www.latex-project.org/lppl.txt
% and version 1.3 or later is part of all distributions of LaTeX version
% 2005/12/01 or later.
%
% This work has the LPPL maintenance status `author-maintained'.
% 
% The Author and Maintainer of this work is Michael C. Davis
%
%
% LICENSE FOR COMPILED WORKS
%
% You may distribute compiled works generated using the work as specified in
% Clause 2 of the LaTeX Project Public License. If you incorporate Open Gaming
% Content into the compiled work, you must also comply with the terms of that
% license.
%
%
% USAGE
%
% See the file module.tex for an example of how to use this class.

% TO DO
%
% 2. Add logo option for contact block
% 3. Move stat blocks into a separate .sty file, keep OGL content separate from other text
% 4. Add all monsters into stat blocks
% 3. Tables incl. wandering monster chart
% 4. Have separate commands for inline stat blocks and new monster stat blocks. The inline one should detect if it is inside the table environment and format itself appropriately.
% 5. Monster stat blocks : inline, table or full text for appendix
% 6. Stat block hit points should be an optional argument, tables can be defined with or without a hit point column.
% 7. Have option for Holmes AC, descending AC or ascending AC with descending AC as default
%
% 8. Set language to US or UK from paper size with option to override to any arbitrary language. Import text for stat blocks from a language-specific include file.
% 9. Perhaps allow system-dependent stat blocks... maybe going too far but at least think of how this could be accomplished and design in a way that allows the possibility in future. Stat blocks could be defined as system-specific as well as language specific.
%
% 10. Free to use but have a PayPal option for donations in case of commercial use...
% 11. Host it online (CTAN? git?). Set up a ticketing system for bugs and/or improvements

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{module}[2016/03/10 Adventure Module document class]



% Process options

\newcounter{numoptions}
\newlength\myoffset

\DeclareOption{a4paper}{
   \stepcounter              {numoptions}

   \setlength\paperheight    {297mm}
   \setlength\paperwidth     {210mm}

   \setlength\myoffset       {-1in}
   \setlength\voffset        \myoffset
   \setlength\hoffset        \myoffset

   \PassOptionsToClass{\CurrentOption}{article}
}
\DeclareOption{letter}{
   \stepcounter              {numoptions}

   \setlength\paperheight    {279.4mm}
   \setlength\paperwidth     {215.9mm}

   \setlength\myoffset       {-1in}
   \addtolength\myoffset     {-17.6mm}
   \setlength\voffset        \myoffset

   \setlength\myoffset       {-1in}
   \addtolength\myoffset     {2.95mm}
   \setlength\hoffset        \myoffset

   \PassOptionsToClass{\CurrentOption}{article}
}
\DeclareOption*{
   \PackageError{dnd_module}{Unrecognised option '\CurrentOption'}{The only valid options are 'a4paper' or 'letter'}
}

\ProcessOptions\relax

\ifcase\thenumoptions
   \PackageError{dnd_module}{Paper size not specified}{The valid paper sizes are 'a4paper' or 'letter'}
\or
   % We got exactly one paper size option, do nothing
\else
   \PackageError{dnd_module}{Multiple paper sizes specified}{The 'a4paper' and 'letter' options are mutually exclusive}
\fi



% This class is based on article, one of the LaTeX base classes

\LoadClass[twocolumn]{article}



% Required packages

\RequirePackage[pass,paperwidth=\paperwidth,paperheight=\paperheight]{geometry}    % Page size
\RequirePackage[explicit,newparttoc]{titlesec}                                     % Redefine section headings
\RequirePackage{titletoc}                                                          % Redefine table of contents
\RequirePackage{framed}                                                            % For boxed text
\RequirePackage{pgfkeys}                                                           % For stat blocks
\input{pgfutil-common}
\input{pgfmath.code}
\RequirePackage{xstring}                                                           % For stat blocks
\RequirePackage{graphicx}                                                          % Allow images and text across two columns
\RequirePackage{dblfloatfix}                                                       % Allow positioning of figure* at bottom of page

% Hyperlinks

\RequirePackage[linktocpage=true]{hyperref}                                        % Allow hyperlinks, only page numbers in TOC are clickable
\RequirePackage[dvipsnames]{xcolor}                                                % Pre-defined colour names
\hypersetup{colorlinks=true,
    urlcolor=blue,                                                                 % Colour for external links
    linkcolor=MidnightBlue,                                                        % Colour for internal links (including Table of Contents)
    citecolor=MidnightBlue}                                                        % Colour for references

% Define font faces and sizes

\RequirePackage[T1]{fontenc}                                                       % Use T1 (8-bit) font encoding
\RequirePackage{avant}                                                             % Use URW Gothic as default sans-serif font (similar to ITC Avant Garde Gothic)
\IfFileExists{souvenir.sty}{
   \RequirePackage{souvenir}                                                       % Use ITC Souvenir as default serifed font (if it exists)
   \renewcommand{\bfdefault}{d}                                                    % Use demi-bold instead of bold
}{
   \PackageWarning{module}{%
      ITC Souvenir not detected, substituting Bookman as default serifed font.}
   \RequirePackage{bookman}                                                        % Use Bookman as default serifed font
}

\renewcommand{\tiny}        {\fontsize {4pt} {4.8pt}\selectfont}
\renewcommand{\scriptsize}  {\fontsize {5pt} {6.0pt}\selectfont}
\renewcommand{\footnotesize}{\fontsize {7pt} {8.4pt}\selectfont}
\renewcommand{\small}       {\fontsize {8pt} {9.6pt}\selectfont}
\renewcommand{\normalsize}  {\fontsize {9pt}{10.8pt}\selectfont}
\renewcommand{\large}       {\fontsize{10pt}{12.0pt}\selectfont}
\renewcommand{\Large}       {\fontsize{11pt}{13.2pt}\selectfont}
\renewcommand{\LARGE}       {\fontsize{13pt}{15.6pt}\selectfont}
\renewcommand{\huge}        {\fontsize{16pt}{19.2pt}\selectfont}
\renewcommand{\Huge}        {\fontsize{17.28pt}{20.74pt}\selectfont}

\renewcommand*\familydefault{\sfdefault}                                           % Default to sans-serif font (URW Gothic)



% Define page dimensions and margins

\setlength{\oddsidemargin}{1cm}
\setlength{\evensidemargin}{1cm}

\setlength{\topmargin}{2.6cm}
\setlength{\headheight}{0cm}
\setlength{\headsep}{0cm}

\setlength{\textheight}{25.4cm}
\setlength{\textwidth}{19cm}

\setlength{\marginparsep}{0cm}
\setlength{\marginparwidth}{0cm}

\setlength{\footskip}{0.7cm}

\pagenumbering{arabic}



% Title Page

\renewcommand\maketitle{\begin{titlepage}
\vspace*{\fill}
\begin{center}
\Huge \textbf{\@title} \par
\vskip 0.5em
\LARGE \textbf{by \@author}
\@subtitle
\@coverimg
\end{center}
\@abstract
\@copyright
\@contact
\vfill
\end{titlepage}
\global\let\maketitle\relax
\global\let\@title\@empty
\global\let\@author\@empty
\global\let\@subtitle\@empty
\global\let\@coverimg\@empty
\global\let\@abstract\@empty
\global\let\@copyright\@empty
\global\let\@contact\@empty
\global\let\title\relax
\global\let\author\relax
}

\def\@subtitle{\relax}
\def\@coverimg{\relax}
\def\@abstract{\relax}
\def\@copyright{\relax}
\def\@contact{\relax}

\newcommand{\subtitle}[1]{\gdef\@subtitle{\vskip 0.5em \LARGE \textbf{\MakeUppercase{#1}}}}
\newcommand{\coverimage}[1]{\gdef\@coverimg{\vskip 1em \includegraphics[width=\textwidth]{#1} \par}}
\renewcommand{\abstract}[1]{\gdef\@abstract{\vskip 0.5em #1 \par}}
\newcommand{\copyrightblock}[1]{\gdef\@copyright{\vskip 0.5em \centering #1 \par}}
\newcommand{\contactblock}[1]{\gdef\@contact{\vskip 0.5em #1 \par}}



% Define headings

\renewcommand\thepart{\arabic{part}}
\renewcommand\thesection{}
\renewcommand\thesubsection{}
\renewcommand\thesubsubsection{\arabic{subsubsection}}

\titleformat{\part}
{\LARGE\filcenter\bfseries}
{\LARGE PART \thepart:}{0.5em}{\MakeUppercase{#1}}

\titleformat{\section}
{\Large\bfseries}
{}{0em}{\MakeUppercase{#1}}

\titleformat{\subsection}
{\large\filcenter\bfseries}
{}{0em}{#1}

\titleformat{\subsubsection}
{\normalfont\bfseries}
{\thesubsubsection.}{0.5em}{\MakeUppercase{#1}}



% Table of Contents

\addtocontents{toc}{\protect\setcounter{tocdepth}{1}}
%\titlecontents{part}[0em]{\large}{PART \thepart:}{NUMBERLESS }{}[\vskip]
\titlecontents{part}[0em]{\large\bfseries}{PART \thecontentslabel : \MakeUppercase}{}{\quad\thecontentspage}[\vspace{0.5em}]
\titlecontents*{section}[0em]{\normalsize}{}{}{~\thecontentspage}[, ][.\vspace{0.5em}]


% Define boxed text

\newcommand{\boxtext}[1]{
\begin{framed}
\noindent #1
\end{framed}
}



% Define one-column minipage

\newenvironment{minipage1col}[1][t]{%
   \begin{figure*}[#1]
   \begin{minipage}{\textwidth}
}{%
   \end{minipage}
   \end{figure*}
}



% Define monster stat blocks

\newcounter{currentstat}

%\newcommand{\descac}{7}
%\pgfmathtruncatemacro{\ascac}{19-\descac}
%\newcommand{\holmesac}{\descac[\ascac]}

\newcommand{\setstatbasic}[2]{%
   \ifcase\thecurrentstat
      \pgfkeys{/#1/AC/.initial  = {#2}}
   \or
      \pgfkeys{/#1/HD/.initial  = {#2}}
   \or
      \pgfkeys{/#1/MV/.initial  = {#2}}
   \or
      \pgfkeys{/#1/Att/.initial = {#2}}
   \or
      \pgfkeys{/#1/Dmg/.initial = {#2}}
   \or
      \pgfkeys{/#1/SV/.initial  = {#2}}
   \or
      \pgfkeys{/#1/ML/.initial  = {#2}}
   \or
      \pgfkeys{/#1/AL/.initial  = {#2}}
   \fi
}

\def\scan@stats#1|{%
   \ifx#1\relax
      \let\next\relax
   \else
      \setstatbasic{\currentmonster}{#1}\let\next\scan@stats
      \stepcounter{currentstat}
  \fi\next
}

\newcommand{\monster}[4][default]{
   \pgfkeys{/#2/SingleName/.initial = {#3}}
      \ifnum\pdfstrcmp{#1}{default}=\z@
      \IfEndWith{#3}{y}
      {\pgfkeys{/#2/PluralName/.initial = \StrGobbleRight{#3}{1}ies}}     % Plural names ending in -y change to -ies
      {
         \IfEndWith{#3}{s}
         {\pgfkeys{/#2/PluralName/.initial = #3es}}                       % Plural names ending in -s change to -ses
         {\pgfkeys{/#2/PluralName/.initial = #3s}}                        % Default case, plurals where we add -s
      }
   \else
      \pgfkeys{/#2/PluralName/.initial = #1}                              % Override for irregular plurals
   \fi
   \setcounter{currentstat}{0}
   \def\currentmonster{#2}
   \scan@stats#4|\relax|
}

\newcommand{\stats}[4][default]{%
   \ifnum\pdfstrcmp{#1}{default}=\z@
      \ifnum\pdfstrcmp{#3}{1}=\z@
         \pgfkeys{/#2/SingleName}:               % Use the generic name defined for this monster (single instance)
      \else
         \pgfkeys{/#2/PluralName} (#3):          % Use the generic name defined for this monster (plural + number appearing)
      \fi
   \else
      #1                                         % Override the generic name with the optional argument
   \fi
   AC      \pgfkeys{/#2/AC},
   HD      \pgfkeys{/#2/HD},
   hp      #4,
   MV      \pgfkeys{/#2/MV},
   Att     \pgfkeys{/#2/Att},
   D       \pgfkeys{/#2/Dmg},
   Save    \pgfkeys{/#2/SV},
   ML      \pgfkeys{/#2/ML},
   AL      \pgfkeys{/#2/AL}%
}

\newenvironment{statblockfreestyle}{\begin{list}{}{\leftmargin=1em\rightmargin=1em}\item}{\end{list}}

\newcommand{\statblock}[4][default]{%
   \begin{statblockfreestyle}
   \stats[#1]{#2}{#3}{#4}
   \end{statblockfreestyle}
}



% Copyright and license macros

\newcommand{\modulecopyright}{%
The \LaTeX~module class is copyright \textcopyright 2016 Michael Davis. It can be distributed and/or modified under the conditions of the
\href{http://www.latex-project.org/lppl.txt}{LaTeX Project Public License}, either version 1.3 or (at your option) any later version. You
have the right to distribute Compiled Works generated using the module class as specified in Clause 3 of the license.}



\newenvironment{ogl}{%
\footnotesize
\subsubsection*{OPEN GAME LICENSE Version 1.0a}
The following text is the property of Wizards of the Coast, Inc. and is Copyright 2000 Wizards of the Coast, Inc (``Wizards''). All Rights Reserved.
\begin{enumerate}
\item Definitions: (a) ``Contributors'' means the copyright and/or trademark owners who have contributed Open Game Content; (b) ``Derivative Material''
means copyrighted material including derivative works and translations (including into other computer languages), potation, modification, correction,
addition, extension, upgrade, improvement, compilation, abridgment or other form in which an existing work may be recast, transformed or adapted; (c)
``Distribute'' means to reproduce, license, rent, lease, sell, broadcast, publicly display, transmit or otherwise distribute; (d) ``Open Game Content''
means the game mechanic and includes the methods, procedures, processes and routines to the extent such content does not embody the Product Identity
and is an enhancement over the prior art and any additional content clearly identified as Open Game Content by the Contributor, and means any work
covered by this License, including translations and derivative works under copyright law, but specifically excludes Product Identity. (e) ``Product
Identity'' means product and product line names, logos and identifying marks including trade dress; artifacts; creatures characters; stories,
storylines, plots, thematic elements, dialogue, incidents, language, artwork, symbols, designs, depictions, likenesses, formats, poses, concepts,
themes and graphic, photographic and other visual or audio representations; names and descriptions of characters, spells, enchantments, personalities,
teams, personas, likenesses and special abilities; places, locations, environments, creatures, equipment, magical or supernatural abilities or effects,
logos, symbols, or graphic designs; and any other trademark or registered trademark clearly identified as Product identity by the owner of the Product
Identity, and which specifically excludes the Open Game Content; (f) ``Trademark'' means the logos, names, mark, sign, motto, designs that are used by
a Contributor to identify itself or its products or the associated products contributed to the Open Game License by the Contributor (g) ``Use'',
``Used'' or ``Using'' means to use, Distribute, copy, edit, format, modify, translate and otherwise create Derivative Material of Open Game Content.
(h) ``You'' or ``Your'' means the licensee in terms of this agreement.

\item The License: This License applies to any Open Game Content that contains a notice indicating that the Open Game Content may only be Used under and
in terms of this License. You must affix such a notice to any Open Game Content that you Use. No terms may be added to or subtracted from this License
except as described by the License itself. No other terms or conditions may be applied to any Open Game Content distributed using this License.

\item Offer and Acceptance: By Using the Open Game Content You indicate Your acceptance of the terms of this License.

\item Grant and Consideration: In consideration for agreeing to use this License, the Contributors grant You a perpetual, worldwide, royalty-free,
non-exclusive license with the exact terms of this License to Use, the Open Game Content.

\item Representation of Authority to Contribute: If You are contributing original material as Open Game Content, You represent that Your Contributions are
Your original creation and/or You have sufficient rights to grant the rights conveyed by this License.

\item Notice of License Copyright: You must update the COPYRIGHT NOTICE portion of this License to include the exact text of the COPYRIGHT NOTICE of any
Open Game Content You are copying, modifying or distributing, and You must add the title, the copyright date, and the copyright holder's name to the
COPYRIGHT NOTICE of any original Open Game Content you Distribute.

\item Use of Product Identity: You agree not to Use any Product Identity, including as an indication as to compatibility, except as expressly licensed in
another, independent Agreement with the owner of each element of that Product Identity. You agree not to indicate compatibility or co-adaptability with any
Trademark or Registered Trademark in conjunction with a work containing Open Game Content except as expressly licensed in another, independent Agreement with
the owner of such Trademark or Registered Trademark. The use of any Product Identity in Open Game Content does not constitute a challenge to the ownership of
that Product Identity. The owner of any Product Identity used in Open Game Content shall retain all rights, title and interest in and to that Product Identity.

\item Identification: If you distribute Open Game Content You must clearly indicate which portions of the work that you are distributing are Open Game Content.

\item Updating the License: Wizards or its designated Agents may publish updated versions of this License. You may use any authorized version of this License
to copy, modify and distribute any Open Game Content originally distributed under any version of this License.

\item Copy of this License: You MUST include a copy of this License with every copy of the Open Game Content You Distribute.

\item Use of Contributor Credits: You may not market or advertise the Open Game Content using the name of any Contributor unless You have written permission
from the Contributor to do so.

\item Inability to Comply: If it is impossible for You to comply with any of the terms of this License with respect to some or all of the Open Game Content
due to statute, judicial order, or governmental regulation then You may not Use any Open Game Material so affected.

\item Termination: This License will terminate automatically if You fail to comply with all terms herein and fail to cure such breach within 30 days of becoming
aware of the breach. All sublicenses shall survive the termination of this License.

\item Reformation: If any provision of this License is held to be unenforceable, such provision shall be reformed only to the extent necessary to make it
enforceable.

\item COPYRIGHT NOTICE
\end{enumerate}
\begin{list}{}{}
\item Open Game License v 1.0 Copyright 2000, Wizards of the Coast, Inc.
}{\end{list}}

\newenvironment{productidentity}{%
\footnotesize
\subsubsection*{Designation of Product Identity}
\begin{list}{}{\leftmargin=0cm}
}{\end{list}}

\newenvironment{opengamecontent}{%
\footnotesize
\subsubsection*{Designation of Open Game Content}
\begin{list}{}{\leftmargin=0cm}
}{\end{list}}
