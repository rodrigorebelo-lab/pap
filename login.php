<?php
declare(strict_types=1);

session_start();
require_once __DIR__ . '/config/db.php';

function esc(string $value): string
{
    return htmlspecialchars($value, ENT_QUOTES | ENT_SUBSTITUTE, 'UTF-8');
}

$errors = [];
$email = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $email = trim($_POST['email'] ?? '');
    $password = $_POST['password'] ?? '';

    if ($email === '' || $password === '') {
        $errors[] = 'Preenche o email e a palavra-passe.';
    } elseif (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
        $errors[] = 'O email nao e valido.';
    } elseif (!$db) {
        $errors[] = 'Sem ligacao a base de dados.';
    } else {
        $stmt = $db->prepare('SELECT id_utilizador, nome, palavra_passe FROM utilizadores WHERE email = ? LIMIT 1');
        $stmt->bind_param('s', $email);
        $stmt->execute();
        $user = $stmt->get_result()->fetch_assoc();

        if (!$user || !password_verify($password, $user['palavra_passe'])) {
            $errors[] = 'Email ou palavra-passe incorretos.';
        } else {
            $_SESSION['user_id'] = (int) $user['id_utilizador'];
            $_SESSION['user_name'] = $user['nome'];
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
    <title>Entrar | Loona</title>
    <link rel="stylesheet" href="/PAP/assets/css/main.css">
</head>
<body>
    <div class="auth-page">
        <form class="form-card" method="post" action="/PAP/login.php">
            <div class="logo">
                <span class="logo-mark">Loona</span>
            </div>
            <h1>Entrar</h1>

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
                    <label for="email">Email</label>
                    <input type="email" id="email" name="email" value="<?= esc($email) ?>" required>
                </div>
                <div class="form-field">
                    <label for="password">Palavra-passe</label>
                    <input type="password" id="password" name="password" required>
                </div>
            </div>

            <div class="form-actions">
                <button class="btn primary" type="submit">Entrar</button>
                <a class="btn ghost" href="/PAP/index.php">Voltar</a>
            </div>

            <p class="form-help">Ainda nao tens conta? <a href="/PAP/signup.php">Criar conta</a></p>
        </form>
    </div>
</body>
</html>