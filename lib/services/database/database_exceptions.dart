class DatabaseExceptions implements Exception {}

class DatabaseAlreadyOpenException implements DatabaseExceptions {}

class DatabaseNotFoundException implements DatabaseExceptions {}

class DatabaseUserAlreadyExistsException implements DatabaseExceptions {}

class DatabaseUserNotFoundException implements DatabaseExceptions {}

class DatabaseCouldNotDeleteUser implements DatabaseExceptions {}

class DatabaseTransactionNotFoundException implements DatabaseExceptions {}

class DatabaseTransactionNotUpdatedException implements DatabaseExceptions {}

class DatabasePersonAlreadyExistsException implements DatabaseExceptions {}
class DatabasePersonamountGreaterThatTotalamountException implements DatabaseExceptions {}

class DatabasePersonNotFoundException implements DatabaseExceptions {}

class DatabasePersonNotUpdatedException implements DatabaseExceptions {}
