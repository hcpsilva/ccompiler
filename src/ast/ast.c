/** ast.c
 *
 * @copyright (C) 2020 Henrique Silva
 *
 *
 * @author Henrique Silva <hcpsilva@inf.ufrgs.br>
 *
 * @section LICENSE
 *
 * This file is subject to the terms and conditions defined in the file
 * 'LICENSE', which is part of this source code package.
 */

#include "ast/ast.h"

cc_lexic_value_t* cc_create_lexic_value(cc_node_data_t data, cc_node_data_kind_t kind, unsigned int line)
{
    cc_lexic_value_t* pointer = (cc_lexic_value_t*)cc_try_malloc(sizeof(cc_lexic_value_t));

    pointer->data = data;
    pointer->line = line;
    pointer->kind = kind;

    return pointer;
}

cc_ast_t* cc_create_ast_node(cc_lexic_value_t* content, cc_ast_t* next, ...)
{
    va_list ap, aux;
    va_start(aux, next);
    va_copy(ap, aux);

    unsigned int param_count = 0;

    while (va_arg(aux, cc_ast_t*) != NULL)
        param_count++;

    va_end(aux); /* free the aux va_list */

    cc_ast_t* pointer = (cc_ast_t*)cc_try_malloc(sizeof(cc_ast_t));

    pointer->content = content;
    pointer->num_children = param_count;

    if (param_count > 0) {
        cc_ast_t** children = (cc_ast_t**)cc_try_malloc(param_count * sizeof(cc_ast_t*));

        for (unsigned int i = 0; i < param_count; i++)
            children[i] = va_arg(ap, cc_ast_t*);

        pointer->children = children;
    } else {
        pointer->children = NULL;
    }

    pointer->next = next;

    va_end(ap); /* free the main va_list */

    return pointer;
}