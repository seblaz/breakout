#include <stdio.h>
#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"

/* 
 * define a function that returns version information to lua scripts
 */
static int hostgetversion(lua_State *l)
{
    /* Push the return values */
    lua_pushnumber(l, 0);
    lua_pushnumber(l, 99);
    lua_pushnumber(l, 32);

    /* Return the count of return values */
    return 3;
}

int main (void)
{
    lua_State *l = luaL_newstate();
    luaL_openlibs(l);

    lua_register(l, "hostgetversion", hostgetversion);

    /* carga script */
    luaL_dofile(l, "mood.lua");

    lua_getglobal(l, "mood");
    lua_pushboolean(l, 1);
    lua_call(l, 1, 1);

    printf("The mood is %s\n", lua_tostring(l, -1));
    lua_pop(l, 1);

    lua_close(l);
    return 0;
}