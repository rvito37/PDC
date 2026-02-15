/*
    classy1.ch

    Class(y) command definitions for backward compatibility with v1.0x

    Copyright (c) 1991-1993 Anton van Straaten
*/

#ifndef CSY1
    #define CSY1
#endif

#include "classy2.ch"


#define     CLASSY_VER100


#xcommand   CREATE CLASS <className> [FROM <superClass>]    ;
                =>                                          ;
                CLASS FUNCTION <className>                  ;;
                metaClass := Class():new(upper(<"className">) + " CLASS", IF(<.superClass.>, [<superClass>():class], Class())) ;;
                self := Class():new(upper(<"className">), CSY_OPT([<superClass>,] Object)()) ;;
                self:addMethods( { { "init", { || init() } } }, CSY_EXPORTED ) ;;
                #include "newclass.ch"

#command    INITIALIZE [CLASS] :            ;
                =>                          ;
                metaClass:addMethods( { { "initClass", { || initClass() } } }, CSY_EXPORTED ) ;;
                self:makeClass(metaClass)   ;;
                self:initClass()            ;;
                end; return self            ;;
                static function initClass   ;;
                local metaClass             ;;
                local initDone := .t.       ;;
                local self := qself()       ;;
                if .t.

#xcommand   END CLASS                       ;
                =>                          ;
                if !initDone                ;;
                self:makeClass(metaClass)   ;;
                end; end; return self       ;;
                #include "endclass.ch"


#xcommand   CLASS VAR <(name1)> [, <(nameN)>] [CLASS <class>] [TYPE <type>] [<ro: READONLY, RO, NOASSIGN>] [ASSIGN <assignScope>] ;
                => ;
                metaClass:addVars( cmsShrClsVar(), { <(name1)> [, <(nameN)>] }, CSY_VARSCOPE( <.ro.> [, <assignScope>] ), [<class>()] [CSY_TYPE <type>] ) ;;
                VAR <(name1)> [, <(nameN)>] TO CLASS (self:name)

#xcommand   CLASS METHOD <method1> [, <methodN>] ;
                => ;
                metaClass:addMethods( { { <"method1">, { || <method1>() } } ;
                                     [, { <"methodN">, { || <methodN>() } }] }, nScope ) ;;
                MESSAGE <method1> [, <methodN>] TO CLASS (self:name)

#xcommand   CLASS METHOD <method1> [, <methodN>] <clause: DEFERRED, NULL>   ;
                =>                                                          ;
                CLASS MESSAGE <method1> [, <methodN>] IS <clause>           ;;
                MESSAGE <method1> [, <methodN>] TO CLASS (self:name)

#xcommand   CLASS MESSAGE <message> METHOD <method> ;
                => ;
                metaClass:addMethods( { { <"message">, { || <method>() } } }, nScope )  ;;
                MESSAGE <message> TO CLASS (self:name)

#xcommand   CLASS MESSAGE <message1> [, <messageN>] <clause: DEFERRED, NULL>;
                =>                                                          ;
                CLASS MESSAGE <message1> [, <messageN>] IS <clause>         ;;
                MESSAGE <message1> [, <messageN>] TO CLASS (self:name)


// other v1.0x command syntaxes
#include "csy1sntx.ch"


// eof classy1.ch
