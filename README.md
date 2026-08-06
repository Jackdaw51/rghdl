# rghdl
An improved version of ghdl written in rust
### Basic workflow explained
The file is read char by char; the **lexer** tokenizes it in **Tokens**, ``Token{Tokenkind}``.\
The **parser** then builds the Abstract Syntax Tree, ``AstArena``, which is a collection of vectors containing the structures. \
Already here lexical rules are imposed, on error they are pushed into the error vector and the parsing goes on.\
Then comes the **Semantic analyzer**, it has to figure out every Symbol meaning and enforce rules like correct assignment to correct type.\
In the same fashion as the parser, when an error is incurred into, it gets pushed into the error vector and semantic analysis goes on. 
