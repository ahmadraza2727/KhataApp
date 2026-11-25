// INFO: login exceptopns

/// after registering the user is null (auth server exceptopn)
class UserNotFoundAuthException implements Exception {}

/// during login the password for email is incorrect
class WrongPasswordAuthException implements Exception {}

// INFO: regster exceptions

/// while registering email is already in use
class EmailAlreadyInUseAuthException implements Exception {}

/// while registering password is weak
class WeakPasswordAuthException implements Exception {}

/// while registering email format is wrong
class InvalidEmailAuthException implements Exception {}

//INFO: Generic exception

/// any form of authentication exception
class GenericAuthException implements Exception {}

/// user cant be acces because user is not logged in or auth server exception
class UserNotLoggedInAuthException implements Exception {}
