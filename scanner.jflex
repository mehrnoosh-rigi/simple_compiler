import java_cup.runtime.*;

%%

%class scanner
%unicode
%cup
%line
%column


%{
	public Boolean debug = false;
  private Symbol symbol(int type,String s) {
	if(debug) System.out.println(s);
    return new Symbol(type, yyline, yycolumn);
  }
  private Symbol symbol(int type,String s, Object value) {
	if(debug) System.out.println(s);
    return new Symbol(type, yyline, yycolumn, value);

  }
%}

 
/* TOKEN1 regular expression */
token1     = "A_"({number_with_sep} | "#"{number_with_sep}{20} |  "#"{number_with_sep}{51})
number = "-"(2[0-3] | 1[0-9] | [1-9]) | [0-9] | [1-9][0-9] | 1[0-9][0-9] | 2[12][0-9] | 23[0-6]
number_with_sep = {number}"#"{number}"#"{number}

/* TOKEN2 regular expression */
token2	= "B_"{date}
date	= 2020" November "(0[6-9] | [12][0-9] | 30) | 2020" December "(0[1-9]| [12][0-9] | 3[01]) | 2021 " Januery "(0[1-9]| [12][0-9] | 3[01]) | 2021 " Februery " 0[1-9]1[0-9]2[0-8] | 2021 " March "(0[1-9]| 1[0-9] | 2[0-8])

/* TOKEN3 regular expression */                        
token3	= "C_"{special_character}
special_character = ("--"| "++" | "-+" | "+-"){6} (("--"| "++" | "-+" | "+-"){2})*

q_string = \" ~ \"

uint	= 0 | [1-9][0-9]*
                    
sep		= "$$$"

comment     = "<<-" ~ "->>"

price = [1-9][0-9]*"."[0-9][0-9]|0?"."[0-9][0-9]
code = "c1"|"c2"|"c3"//change this


%%

{token1}			{return symbol(sym.TOKEN1,"TOKEN1");}
{token2}			{return symbol(sym.TOKEN2,"TOKEN2");}
{token3}			{return symbol(sym.TOKEN3,"TOKEN3");}

{q_string}			{return symbol(sym.QSTRING,"QSTRING",new String(yytext()));}
{uint}				{return symbol(sym.UINT,yytext(), new Integer(yytext()));}

{sep}				{return symbol(sym.SEP,"SEP");}
{price}				{return symbol(sym.PRICE,"PRICE");}
{code} 				{return symbol(sym.CODE,"CODE",new String(yytext()));}


"_"	        		{return symbol(sym.UNDERSCORE,"UNDERSCORE");}
"euro"				{return symbol(sym.EURO,"EURO");}
"%"					{return symbol(sym.PERCENTAGE,"PERCENTAGE");}
"-"					{return symbol(sym.MINUS,"MINUS");}
"," 				{return symbol(sym.CM,"CM");}
";" 				{return symbol(sym.S,"S");}
"::" 				{return symbol(sym.DC,"DC");}


{comment}	 		{;}
\r | \n | \r\n | " " | \t	{;}
.         {System.out.println("Errore: " + (yyline+1) + " " + (yycolumn+1) + ": " + yytext());}