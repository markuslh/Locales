#
# Locales: ConstructibleObjectsAsUnionOfDifferences
#
# Implementations
#

##
InstallMethod( IsHomSetInhabitedWithTypeCast,
        "for an object in a meet-semilattice of formal differences and a constructible object as a union of formal differences",
        [ IsObjectInMeetSemilatticeOfDifferences, IsConstructibleObjectAsUnionOfDifferences ],

  function( A, B )
    local Ap, P, Bp, b;
    
    A := PairInUnderlyingLattice( A );
    
    Ap := A[2];
    A := A[1];
    
    P := CapCategory( A );
    
    B := ListOfObjectsInMeetSemilatticeOfDifferences( B );
    
    B := List( B, PairInUnderlyingLattice );
    
    Bp := List( B, a -> a[2] );
    B := List( B, a -> a[1] );
    
    b := Length( B );
    
    ## TODO: remove List( iterator ) once GAP supports List with an iterator as 1st argument
    return ForAll( [ 0 .. b ],
                   i -> ForAll( List( IteratorOfCombinations( [ 1 .. b ], i ) ),
                           I -> IsHomSetInhabited(
                                   DirectProduct( Concatenation( [ A ], Bp{I} ) ),
                                   Coproduct( Concatenation( [ Ap ], B{Difference( [ 1 .. b ], I )} ) ) ) ) );
    
end );

##
InstallMethod( BooleanAlgebraOfConstructibleObjectsAsUnionOfDifferences,
        "for a CAP category",
        [ IsCapCategory and IsThinCategory ],
        
  function( P )
    local name, C;
    
    name := "The Boolean algebra of constructible objects of ";
    
    name := Concatenation( name, Name( P ) );
    
    C := CreateCapCategory( name );
    
    C!.UnderlyingCategory := P;
    C!.MeetSemilatticeOfDifferences := MeetSemilatticeOfDifferences( P );
    
    AddObjectRepresentation( C, IsConstructibleObjectAsUnionOfDifferences );
    
    AddMorphismRepresentation( C, IsMorphismBetweenConstructibleObjectsAsUnionOfDifferences );
    
    ADD_COMMON_METHODS_FOR_BOOLEAN_ALGEBRAS( C );
    
    ##
    AddIsWellDefinedForObjects( C,
      function( A )
        local U;
        
        U := ListOfObjectsInMeetSemilatticeOfDifferences( A );
        
        return ForAll( U, IsWellDefinedForObjects );
        
    end );
    
    ##
    AddIsHomSetInhabited( C,
      function( A, B )
        
        A := ListOfObjectsInMeetSemilatticeOfDifferences( A );
        
        return ForAll( A, M -> IsHomSetInhabitedWithTypeCast( M, B ) );
        
    end );
    
    ##
    AddTerminalObject( C,
      function( arg )
        local T;
        
        T := TerminalObject( C!.MeetSemilatticeOfDifferences );
        
        return UnionOfDifferences( T );
        
    end );
    
    ##
    AddInitialObject( C,
      function( arg )
        local I;
        
        I := InitialObject( C!.MeetSemilatticeOfDifferences );
        
        return UnionOfDifferences( I );
        
    end );
    
    ##
    AddIsInitial( C,
      function( A )
        
        A := ListOfObjectsInMeetSemilatticeOfDifferences( A );
        
        return ForAll( A, IsInitial );
        
    end );
    
    ##
    AddDirectProduct( C,
      function( L )
        local l, I, U;
        
        L := List( L, ListOfObjectsInMeetSemilatticeOfDifferences );
        
        l := [ 1 .. Length( L ) ];
        
        ## TODO: replace Cartesian -> IteratorOfCartesianProduct once GAP supports List with an iterator as 1st argument
        I := Cartesian( List( L, a -> [ 1 .. Length( a ) ] ) );
        
        ## the distributive law
        U := List( I, i -> DirectProduct( List( l, j -> L[j][i[j]] ) ) );
        
        return CallFuncList( UnionOfDifferences, U );
        
    end );
    
    ##
    AddCoproduct( C,
      function( L )
        
        L := List( L, ListOfObjectsInMeetSemilatticeOfDifferences );
        
        ## an advantage of this this specific data structure for constructible objects
        return CallFuncList( UnionOfDifferences, Concatenation( L ) );
        
    end );
    
    Finalize( C );
    
    return C;
    
end );

##
InstallGlobalFunction( UnionOfDifferences,
  function( arg )
    local A, C;
    
    A := rec( );
    
    arg := List( arg,
                 function( A )
                   if IsConstructibleObjectAsUnionOfDifferences( A ) then
                       return ListOfObjectsInMeetSemilatticeOfDifferences( A );
                   elif IsObjectInMeetSemilatticeOfDifferences( A ) then
                       return A;
                   elif IsObjectInThinCategory( A ) then
                       return A - 0;
                   else
                       Error( "this entry is neither a constructible set as a union of formal differences, nor a formal difference, nor a formal difference, not even an object in a thin category: ", A, "\n" );
                   fi;
               end );
    
    arg := Flat( arg );
    
    C := BooleanAlgebraOfConstructibleObjectsAsUnionOfDifferences(
                 CapCategory( PairInUnderlyingLattice( arg[1] )[1] ) );
    
    ObjectifyObjectForCAPWithAttributes( A, C,
            ListOfPreObjectsInMeetSemilatticeOfDifferences, arg
            );
    
    Assert( 4, IsWellDefined( A ) );
    
    return A;
    
end );

##
InstallMethod( \+,
        "for an object in a meet-semilattice of formal differences and an object in a thin category",
        [ IsObjectInMeetSemilatticeOfDifferences, IsObjectInThinCategory ],
        
  UnionOfDifferences );

##
InstallMethod( \+,
        "for an object in a thin category and an object in a meet-semilattice of formal differences",
        [ IsObjectInThinCategory, IsObjectInMeetSemilatticeOfDifferences ],
        
  UnionOfDifferences );

##
InstallMethod( \+,
        "for an object in a meet-semilattice of formal differences and an object in a thin category",
        [ IsObjectInMeetSemilatticeOfDifferences, IsObjectInThinCategory ],
        
  UnionOfDifferences );

##
InstallMethod( \+,
        "for an object in a thin category and an object in a meet-semilattice of formal differences",
        [ IsObjectInThinCategory, IsObjectInMeetSemilatticeOfDifferences ],
        
  UnionOfDifferences );

##
InstallMethod( \+,
        "for a constructible object as a union of formal differences and an object in a thin category",
        [ IsConstructibleObjectAsUnionOfDifferences, IsObjectInThinCategory ],
        
  UnionOfDifferences );

##
InstallMethod( \+,
        "for an object in a meet-semilattice of formal differences and the zero integer",
        [ IsObjectInMeetSemilatticeOfDifferences, IsInt and IsZero ],
        
  function( A, B )
    
    return A + InitialObject( CapCategory( A ) );
    
end );

##
InstallMethod( \+,
        "for the zero integer and an object in a meet-semilattice of formal differences",
        [ IsInt and IsZero, IsObjectInMeetSemilatticeOfDifferences ],
        
  function( A, B )
    
    return B + InitialObject( CapCategory( B ) );
    
end );

##
InstallMethod( \+,
        "for an object in a thin category and the zero integer",
        [ IsObjectInThinCategory, IsInt and IsZero ],
        
  function( A, B )
    
    return ( A - 0 ) + 0;
    
end );

##
InstallMethod( \+,
        "for the zero integer and an object in a thin category",
        [ IsInt and IsZero, IsObjectInThinCategory ],
        
  function( A, B )
    
    return ( B - 0 ) + 0;
    
end );

##
InstallGlobalFunction( UnionOfDifferencesOfNormalizedObjects,
  function( arg )
    local A, C;
    
    A := rec( );

    C := BooleanAlgebraOfConstructibleObjectsAsUnionOfDifferences(
                 CapCategory( PairInUnderlyingLattice( ListOfObjectsInMeetSemilatticeOfDifferences( arg[1] )[1] )[1] ) );
    
    ObjectifyObjectForCAPWithAttributes( A, C,
            ListOfNormalizedObjectsInMeetSemilatticeOfDifferences, arg
            );
    
    Assert( 4, IsWellDefined( A ) );
    
    return A;
    
end );

##
InstallMethod( ListOfNormalizedObjectsInMeetSemilatticeOfDifferences,
        "for a constructible object as a union of formal differences",
        [ IsConstructibleObjectAsUnionOfDifferences ],
        
  function( A )
    
    return List( ListOfObjectsInMeetSemilatticeOfDifferences( A ), NormalizedObject );
    
end );

##
InstallMethod( ListOfStandardObjectsInMeetSemilatticeOfDifferences,
        "for a constructible object as a union of formal differences",
        [ IsConstructibleObjectAsUnionOfDifferences ],
        
  function( A )
    
    return List( ListOfObjectsInMeetSemilatticeOfDifferences( A ), StandardObject );
    
end );

##
InstallMethod( ListOfObjectsInMeetSemilatticeOfDifferences,
        "for a constructible object as a union of formal differences",
        [ IsConstructibleObjectAsUnionOfDifferences ],
        
  ListOfPreObjectsInMeetSemilatticeOfDifferences );

##
InstallMethod( ListOfObjectsInMeetSemilatticeOfDifferences,
        "for a constructible object as a union of formal differences",
        [ IsConstructibleObjectAsUnionOfDifferences and HasListOfNormalizedObjectsInMeetSemilatticeOfDifferences ],
        
  ListOfNormalizedObjectsInMeetSemilatticeOfDifferences );

##
InstallMethod( ListOfObjectsInMeetSemilatticeOfDifferences,
        "for a constructible object as a union of formal differences",
        [ IsConstructibleObjectAsUnionOfDifferences and HasListOfStandardObjectsInMeetSemilatticeOfDifferences ],
        
  ListOfStandardObjectsInMeetSemilatticeOfDifferences );

##
InstallMethod( ListOp,
        "for a constructible object as a union of formal differences",
        [ IsConstructibleObjectAsUnionOfDifferences ],
        
  ListOfObjectsInMeetSemilatticeOfDifferences );

##
InstallMethod( ListOp,
        "for a constructible object as a union of formal differences and a function",
        [ IsConstructibleObjectAsUnionOfDifferences, IsFunction ],
        
  function( A, f )
    
    return List( ListOfObjectsInMeetSemilatticeOfDifferences( A ), f );
    
end );

##
InstallMethod( Length,
        "for a constructible object as a union of formal differences",
        [ IsConstructibleObjectAsUnionOfDifferences ],
        
  C -> Length( ListOfObjectsInMeetSemilatticeOfDifferences( C ) ) );

##
InstallMethod( NormalizedObject,
        "for a constructible object as a union of formal differences",
        [ IsConstructibleObjectAsUnionOfDifferences ],
        
  function( A )
    local L;
    
    L := Filtered( ListOfNormalizedObjectsInMeetSemilatticeOfDifferences( A ), m -> not IsInitial( m ) );
    
    if L = [ ] then
        return InitialObject( A );
    fi;
    
    return CallFuncList( UnionOfDifferences, L );
    
end );

##
InstallMethod( StandardObject,
        "for a constructible object as a union of formal differences",
        [ IsConstructibleObjectAsUnionOfDifferences ],
        
  function( A )
    local L;
    
    L := Filtered( ListOfStandardObjectsInMeetSemilatticeOfDifferences( A ), m -> not IsInitial( m ) );
    
    if L = [ ] then
        return InitialObject( A );
    fi;
    
    return CallFuncList( UnionOfDifferences, L );
    
end );

##
InstallMethod( \-,
        "for an object in a thin category and an object in a meet-semilattice of formal differences",
        [ IsObjectInThinCategory, IsObjectInMeetSemilatticeOfDifferences ],
        
  function( A, B )
    
    B := PairInUnderlyingLattice( B );
    
    return ( A - B[1] ) + A * B[2];
    
end );

##
InstallMethod( \-,
        "for two objects in a meet-semilattice of formal differences",
        [ IsObjectInMeetSemilatticeOfDifferences, IsObjectInMeetSemilatticeOfDifferences ],
        
  function( A, B )
    
    A := PairInUnderlyingLattice( A );
    B := PairInUnderlyingLattice( B );
    
    return ( A[1] - ( A[2] + B[1] ) ) + ( ( A[1] * B[2] ) - A[2] );
    
end );

##
InstallMethod( \-,
        "for an object in a thin category and a constructible object as a union of formal differences",
        [ IsObjectInThinCategory, IsConstructibleObjectAsUnionOfDifferences ],
        
  function( A, B )
    
    B := ListOfObjectsInMeetSemilatticeOfDifferences( B );
    
    return DirectProduct( List( B, b -> A - b ) );
    
end );

##
InstallMethod( \-,
        "for a constructible object as a union of formal differences and an object in a thin category",
        [ IsConstructibleObjectAsUnionOfDifferences, IsObjectInThinCategory ],
        
  function( A, B )
    
    A := ListOfObjectsInMeetSemilatticeOfDifferences( A );
    
    return CallFuncList( UnionOfDifferences, List( A, a -> a - B ) );
    
end );

##
InstallMethod( AdditiveInverseMutable,
        "for an object in a meet-semilattice of formal differences",
        [ IsObjectInMeetSemilatticeOfDifferences ],
        
  function( A )
    
    return -( A + 0 );
    
end );

##
InstallMethod( Closure,
        "for a constructible object as a union of formal differences",
        [ IsConstructibleObjectAsUnionOfDifferences ],
        
  function( A )
    local H;
    
    H := CapCategory( A )!.UnderlyingCategory;
    
    if HasIsCocartesianCoclosedCategory( H ) and IsCocartesianCoclosedCategory( H ) then
        return Coproduct( List( ListOfObjectsInMeetSemilatticeOfDifferences( A ), Closure ) );
    fi;
    
    TryNextMethod( );
    
end );

##
InstallMethod( ClosureAsConstructibleObject,
        "for a constructible object as a union of formal differences",
        [ IsConstructibleObjectAsUnionOfDifferences ],
        
  function( A )
    
    return ( Closure( A ) - 0 ) + 0;
    
end );

##
InstallMethod( \=,
        "for an object in a thin category and a constructible object as a union of formal differences",
        [ IsObjectInThinCategory, IsConstructibleObjectAsUnionOfDifferences ],
        
  function( A, B )
    
    if IsConstructibleObjectAsUnionOfDifferences( A ) then
        TryNextMethod( );
    fi;
    
    return ( A + 0 ) = B;
    
end );

##
InstallMethod( \=,
        "for a constructible object as a union of formal differences and an object in a thin category",
        [ IsConstructibleObjectAsUnionOfDifferences, IsObjectInThinCategory ],
        
  function( A, B )
    
    if IsConstructibleObjectAsUnionOfDifferences( B ) then
        TryNextMethod( );
    fi;
    
    return A = ( B + 0 );
    
end );

##
InstallMethod( \.,
        "for a constructible object as a union of formal differences and a positive integer",
        [ IsConstructibleObjectAsUnionOfDifferences, IsPosInt ],
        
  function( A, string_as_int )
    local name, n;
    
    A := ListOfObjectsInMeetSemilatticeOfDifferences( A );
    
    name := NameRNam( string_as_int );
    
    n := EvalString( name{[ 2 .. Length( name ) ]} );
    
    if name[1] = 'I' then
        return A[n].I;
    elif name[1] = 'J' then
        return A[n].J;
    fi;
    
    Error( "no component with this name available\n" );
    
end );

##
InstallMethod( \[\],
        "for a constructible object as a union of formal differences and a positive integer",
        [ IsConstructibleObjectAsUnionOfDifferences, IsPosInt ],
        
  function( A, pos )
    
    return ListOfObjectsInMeetSemilatticeOfDifferences( A )[pos];
    
end );

##
InstallMethod( ViewObj,
        "for a constructible object as a union of formal differences",
        [ IsConstructibleObjectAsUnionOfDifferences ],

  function( A )
    local n, i;
    
    A := ListOfObjectsInMeetSemilatticeOfDifferences( A );
    
    n := Length( A );
    
    Print( "( " );
    ViewObj( A[1] : Locales_number := "1" );
    
    for i in [ 2 .. n ] do
        Print( " ) + ( " );
        ViewObj( A[i] : Locales_number := String( i ) );
    od;
    
    Print( " )" );
    
end );

##
InstallMethod( DisplayString,
        "for a constructible object as a union of formal differences",
        [ IsConstructibleObjectAsUnionOfDifferences ],

  function( A )
    local n, display, i;
    
    A := ListOfObjectsInMeetSemilatticeOfDifferences( A );
    
    n := Length( A );
    
    display := DisplayString( A[1] );
    
    for i in [ 2 .. n ] do
        Append( display, "\n\n+\n\n" );
        Append( display, DisplayString( A[i] ) );
    od;
    
    return display;
    
end );
