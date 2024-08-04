<?php

header('Content-Type: application/json');

// Get the JSON data from the request body
$jsonData = file_get_contents('php://input');
$data = json_decode($jsonData, true);

if ($data !== null) {
    // Strip tags from the email and password inputs
    $email = strip_tags($data['email']);
    $password = strip_tags($data['password']);

    // Hash the password
    $hashedPassword = password_hash($password, PASSWORD_DEFAULT);

    // Connect to the database
    $con = new mysqli("fdb1030.awardspace.net", "4510429_netflix", "IM!17122004", "4510429_netflix");

    // Check the database connection
    if ($con->connect_error) {
        echo json_encode(['status' => 'error', 'message' => 'Connection failed: ' . $con->connect_error]);
        exit();
    }

    // Check if the email already exists
    $checkStmt = $con->prepare("SELECT * FROM users WHERE email = ?");
    if ($checkStmt === false) {
        echo json_encode(['status' => 'error', 'message' => 'Prepare failed: ' . $con->error]);
        exit();
    }
    $checkStmt->bind_param("s", $email);
    $checkStmt->execute();
    $result = $checkStmt->get_result();

    if ($result->num_rows > 0) {
        echo json_encode(['status' => 'error', 'message' => 'User already registered']);
        $checkStmt->close();
        $con->close();
        exit();
    }
    $checkStmt->close();

    // Prepare the SQL statement to insert a new user
    $stmt = $con->prepare("INSERT INTO users (email, password) VALUES (?, ?)");
    if ($stmt === false) {
        echo json_encode(['status' => 'error', 'message' => 'Prepare failed: ' . $con->error]);
        exit();
    }

    // Bind the email and hashed password parameters
    $stmt->bind_param("ss", $email, $hashedPassword);

    // Execute the statement and check for errors
    if ($stmt->execute()) {
        echo json_encode(['status' => 'success', 'message' => 'Record added']);
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Execute failed: ' . $stmt->error]);
    }

    // Close the statement and connection
    $stmt->close();
    $con->close();
} else {
    echo json_encode(['status' => 'error', 'message' => 'Invalid JSON data']);
}
?>
