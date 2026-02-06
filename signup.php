<?php
declare(strict_types=1);

session_start();
require_once __DIR__ . '/config/db.php';

function esc(string $value): string
{
    return htmlspecialchars($value, ENT_QUOTES | ENT_SUBSTITUTE, 'UTF-8');
}

$errors = [];
$nome = '';
$email = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $nome = trim($_POST['nome'] ?? '');
    $email = trim($_POST['email'] ?? '');
    $password = $_POST['password'] ?? '';
    $confirm = $_POST['confirm'] ?? '';

    if ($nome === '' || $email === '' || $password === '' || $confirm === '') {
        $errors[] = 'Preenche todos os campos.';
    } elseif (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
        $errors[] = 'O email nao e valido.';
    } elseif (strlen($password) < 6) {
        $errors[] = 'A palavra-passe deve ter pelo menos 6 caracteres.';
    } elseif ($password !== $confirm) {
        $errors[] = 'As palavras-passe nao coincidem.';
    } elseif (!$db) {
        $errors[] = 'Sem ligacao a base de dados.';
    } else {
        $stmt = $db->prepare('SELECT id_utilizador FROM utilizadores WHERE email = ? LIMIT 1');
        $stmt->bind_param('s', $email);
        $stmt->execute();
        if ($stmt->get_result()->fetch_assoc()) {
            $errors[] = 'Esse email ja esta registado.';
        } else {
            $hash = password_hash($password, PASSWORD_DEFAULT);
            $insert = $db->prepare('INSERT INTO utilizadores (nome, email, palavra_passe) VALUES (?, ?, ?)');
            $insert->bind_param('sss', $nome, $email, $hash);
            $insert->execute();
            $_SESSION['user_id'] = (int) $insert->insert_id;
            $_SESSION['user_name'] = $nome;
            header('Location: /PAP/index.php');
            exit;
        }
    }
}
?>
<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Criar conta | Loona</title>
    <link rel="stylesheet" href="/PAP/assets/css/main.css">
</head>
<body>
    <div class="auth-page">
        <form class="form-card" method="post" action="/PAP/signup.php">
            <div class="logo">
                <span class="logo-mark">Loona</span>
            </div>
            <h1>Criar conta</h1>

            <?php if (!empty($db_error)) : ?>
                <div class="alert">Ligacao a base de dados falhou: <?= esc($db_error) ?></div>
            <?php endif; ?>

            <?php if ($errors) : ?>
                <div class="alert">
                    <?= esc(implode(' ', $errors)) ?>
                </div>
            <?php endif; ?>

            <div class="form-grid">
                <div class="form-field">
                    <label for="nome">Nome</label>
                    <input type="text" id="nome" name="nome" value="<?= esc($nome) ?>" required>
                </div>
                <div class="form-field">
                    <label for="email">Email</label>
                    <input type="email" id="email" name="email" value="<?= esc($email) ?>" required>
                </div>
                <div class="form-field">
                    <label for="password">Palavra-passe</label>
                    <input type="password" id="password" name="password" required>
                </div>
                <div class="form-field">
                    <label for="confirm">Confirmar palavra-passe</label>
                    <input type="password" id="confirm" name="confirm" required>
                </div>
            </div>

            <div class="form-actions">
                <button class="btn primary" type="submit">Criar conta</button>
                <a class="btn ghost" href="/PAP/index.php">Voltar</a>
            </div>

            <p class="form-help">Ja tens conta? <a href="/PAP/login.php">Entrar</a></p>
        </form>
    </div>
</body>
</html>