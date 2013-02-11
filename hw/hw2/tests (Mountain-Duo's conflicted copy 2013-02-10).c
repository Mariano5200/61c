/* Tests for hw2 */

#include <stdio.h>
#include <assert.h>
#include <stdarg.h>
#include "matcher.c"

int main(int argc, char **argv) {
    // testing for special chars.
    printf("Special Chars:\n");
    printf("* is special; %d\n", isSpecial('*'));
    printf(". is special; %d\n", isSpecial('.'));
    printf("\\ is special; %d\n", isSpecial('\\'));
    printf("a isn't special; %d\n\n", isSpecial('a'));

    //simple test cases.
    printf("Simple Tests--no special chars: \n");
    char *ln1 = "ab";
    char *pat1 = "a";
    assert(rgrep_matches(ln1,pat1));
    printf("%s matches %s; %d\n", ln1, pat1, rgrep_matches(ln1,pat1));
    printf("%s matches %s; %d\n", pat1, ln1, rgrep_matches(pat1,ln1));
    char *pat2 = "b";
    printf("%s matches %s; %d\n", ln1, pat2, rgrep_matches(ln1,pat2));
    printf("%s matches %s; %d\n", pat2, ln1, rgrep_matches(pat2,ln1));
    char *pat3 = ".b";
    printf("%s matches %s; %d\n", ln1, pat3, rgrep_matches(ln1,pat3));
    printf("%s matches %s; %d\n", pat3, ln1, rgrep_matches(pat3,ln1));
    
    
    return 0;
}