<?php

mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);

$servername =  getenv("MYSQL_HOST");
$username = getenv("MYSQL_USER");
$password = getenv("MYSQL_PASSWORD");
$port = getenv("MYSQL_PORT");
$database = getenv("MYSQL_DATABASE");

$connectionCount = 0;
$isConnected = false;

do {
  try {
    // Create connection
    $conn = new mysqli($servername, $username, $password, null, $port);
    $isConnected = true;
  } catch (Exception $e) {
    printf("Connect failed: %s\n", mysqli_connect_error());
    printf("Trying again in 5 secconds \n");
  }

  $connectionCount++;
  sleep(5);
} while (!($connectionCount >= 10 || $isConnected));

// Check connection
if (!$isConnected) {
  printf("Cant connect to database:%s\n", $conn->connect_error);
  exit(1);
}

printf("Connected successfully \n");

$query = $conn->query("SHOW DATABASES LIKE '$database'");
$row = $query->fetch_object();

if ($row === NULL) {
  $queryCreateDB = $conn->query("CREATE DATABASE '$database'");
  printf("Database created with name: '$database' \n");
  $queryCreateDB->close();
} else {
  printf("Database '$database' exists \n");
}

$query->close();
$conn->close();

exit(0);

?>