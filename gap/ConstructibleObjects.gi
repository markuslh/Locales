#
# Locales: ConstructibleObjects
#
# Implementations
#

##
InstallMethod( \-,
        "for a constructible object and the zero integer",
        [ IsConstructibleObject, IsInt and IsZero ],
        
  function( A, B )
    
    return A;
    
end );

##
InstallMethod( AdditiveInverseMutable,
        "for a constructible object",
        [ IsConstructibleObject ],
        
  function( A )
    
    return TerminalObject( A ) - A;
    
end );

##
InstallMethod( IsClosedSubobject,
        "for a constructible object",
        [ IsConstructibleObject ],
        
  function( A )
    
    return IsEqualForObjectsIfIsHomSetInhabited( A, ClosureAsConstructibleObject( A ) );
    
end );

##
InstallMethod( IsClosed,
        "for a constructible object",
        [ IsConstructibleObject ],
        
  IsClosedSubobject );

##
InstallMethod( IsOpen,
        "for a constructible object",
        [ IsConstructibleObject ],
        
  function( A )
    
    return IsClosed( -A );
    
end );

##
InstallMethod( IsLocallyClosed,
        "for a constructible object",
        [ IsConstructibleObject ],
        
  function( A )
    
    return IsClosed( Closure( A ) - A );
    
end );

##
InstallMethod( LocallyClosedApproximation,
        "for a constructible object",
        [ IsConstructibleObject ],
        
  function( A )
    local C;
    
    C := Closure( A );
    
    if IsClosed( A ) then
        return C;
    fi;
    
    return C - Closure( C - A );
    
end );

##
InstallMethod( CanonicalObject,
        "for a constructible object",
        [ IsConstructibleObject ],
        
  function( A )
    local C;
    
    if IsInitial( A ) then
        return InitialObject( A );
    fi;
    
    C := LocallyClosedApproximation( A );
    
    A := A - C;
    
    while not IsInitial( A ) do
        
        C := C + LocallyClosedApproximation( A );
        
        A := A - C;
        
    od;
    
    return C;
    
end );

##
InstallMethod( Dimension,
        "for a constructible object",
        [ IsConstructibleObject ],
        
  function( A )
    
    return Dimension( Closure( A ) );
    
end );

##
InstallMethod( Display,
        "for a constructible object",
        [ IsConstructibleObject ],

  function( A )
    
    Display( DisplayString( A ) );
    
end );
