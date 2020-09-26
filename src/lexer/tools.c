/** tools.c
 *
 * @file
 * @author Henrique Silva <hcpsilva@inf.ufrgs.br>
 * @author Bernardo Hummes <bhflores@inf.ufrgs.br>
 *
 * @section LICENSE
 *
 * This file is subject to the terms and conditions defined in the file
 * 'LICENSE', which is part of this source code package.
 */

#include "lexer/tools.h"

unsigned int cc_match_line_number(void)
{
    return (unsigned int)yylineno;
}

void cc_update_line_buffer(char* text, size_t match_lenght)
{
    if (match_lenght + 1 > yylinebuf_len) {
        yylinebuf = (char*)cc_try_realloc(yylinebuf, (match_lenght + 100) * sizeof(char));
        yylinebuf_len = match_lenght + 100;
    }
    strncpy(yylinebuf, text, yylinebuf_len - 1);
}