<?php

header('Content-Type: application/json');

// Get the JSON data from the request body
$jsonData = file_get_contents('php://input');
$data = json_decode($jsonData, true);

if ($data !== null) {
    // Strip tags from the email and password inputs
    $email = filter_var($data['email'], FILTER_SANITIZE_EMAIL);
    $password = strip_tags($data['password']);

    // Validate the email
    if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
        echo json_encode(['status' => 'error', 'message' => 'Invalid email address']);
        exit();
    }

    // Connect to the database
    $con = new mysqli("fdb1030.awardspace.net", "4510429_netflix", "IM!17122004", "4510429_netflix");

    // Check the database connection
    if ($con->connect_error) {
        echo json_encode(['status' => 'error', 'message' => 'Connection failed: ' . $con->connect_error]);
        exit();
    }

    // Prepare the SQL statement to fetch the user by email
    $stmt = $con->prepare("SELECT password FROM users WHERE email = ?");
    if ($stmt === false) {
        echo json_encode(['status' => 'error', 'message' => 'Prepare failed: ' . $con->error]);
        exit();
    }
    $stmt->bind_param("s", $email);
    $stmt->execute();
    $stmt->store_result();

    // Check if the email exists
    if ($stmt->num_rows === 0) {
        echo json_encode(['status' => 'error', 'message' => 'Invalid email or password']);
        $stmt->close();
        $con->close();
        exit();
    }

    // Fetch the hashed password
    $stmt->bind_result($hashedPassword);
    $stmt->fetch();
    $stmt->close();

    // Verify the password
    if (password_verify($password, $hashedPassword)) {
        echo json_encode(['status' => 'success', 'message' => 'Sign-in successful']);
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Invalid email or password']);
    }

    // Close the connection
    $con->close();
} else {
    echo json_encode(['status' => 'error', 'message' => 'Invalid JSON data']);
}

?>
