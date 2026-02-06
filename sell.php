<?php
declare(strict_types=1);

session_start();
require_once __DIR__ . '/config/db.php';

function esc(string $value): string
{
    return htmlspecialchars($value, ENT_QUOTES | ENT_SUBSTITUTE, 'UTF-8');
}

if (empty($_SESSION['user_id'])) {
    header('Location: /PAP/login.php');
    exit;
}

$errors = [];
$titulo = '';
$descricao = '';
$preco = '';
$estado = 'usado';
$categoria = '';
$imagem = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $titulo = trim($_POST['titulo'] ?? '');
    $descricao = trim($_POST['descricao'] ?? '');
    $preco = trim($_POST['preco'] ?? '');
    $estado = $_POST['estado'] ?? 'usado';
    $categoria = trim($_POST['categoria'] ?? '');
    $imagem = trim($_POST['imagem'] ?? '');

    if ($titulo === '' || $preco === '') {
        $errors[] = 'Titulo e preco sao obrigatorios.';
    }

    $precoNormalizado = str_replace(',', '.', $preco);
    if ($precoNormalizado === '' || !is_numeric($precoNormalizado) || (float) $precoNormalizado <= 0) {
        $errors[] = 'Preco invalido.';
    }

    if (!in_array($estado, ['novo', 'usado'], true)) {
        $errors[] = 'Estado invalido.';
    }

    if ($imagem !== '' && !filter_var($imagem, FILTER_VALIDATE_URL)) {
        $errors[] = 'O URL da imagem nao e valido.';
    }

    if (!$db) {
        $errors[] = 'Sem ligacao a base de dados.';
    }

    if (!$errors) {
        $idCategoria = null;
        if ($categoria !== '') {
            $stmt = $db->prepare('SELECT id_categoria FROM categorias WHERE nome = ? LIMIT 1');
            $stmt->bind_param('s', $categoria);
            $stmt->execute();
            $row = $stmt->get_result()->fetch_assoc();
            if ($row) {
                $idCategoria = (int) $row['id_categoria'];
            } else {
                $insertCat = $db->prepare('INSERT INTO categorias (nome) VALUES (?)');
                $insertCat->bind_param('s', $categoria);
                $insertCat->execute();
                $idCategoria = (int) $insertCat->insert_id;
            }
        }

        $idUser = (int) $_SESSION['user_id'];
        $precoFloat = (float) $precoNormalizado;

        if ($idCategoria === null) {
            $stmt = $db->prepare('INSERT INTO produtos (id_utilizador, titulo, descricao, preco, id_categoria, estado, status) VALUES (?, ?, ?, ?, NULL, ?, \"ativo\")');
            $stmt->bind_param('issds', $idUser, $titulo, $descricao, $precoFloat, $estado);
        } else {
            $stmt = $db->prepare('INSERT INTO produtos (id_utilizador, titulo, descricao, preco, id_categoria, estado, status) VALUES (?, ?, ?, ?, ?, ?, \"ativo\")');
            $stmt->bind_param('issdis', $idUser, $titulo, $descricao, $precoFloat, $idCategoria, $estado);
        }

        $stmt->execute();
        $idProduto = (int) $stmt->insert_id;

        if ($imagem !== '') {
            $img = $db->prepare('INSERT INTO imagens_produto (id_produto, url_imagem) VALUES (?, ?)');
            $img->bind_param('is', $idProduto, $imagem);
            $img->execute();
        }

        header('Location: /PAP/index.php');
        exit;
    }
}
?>
<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Publicar produto | Loona</title>
    <link rel="stylesheet" href="/PAP/assets/css/main.css">
</head>
<body>
    <div class="auth-page">
        <form class="form-card" method="post" action="/PAP/sell.php">
            <div class="logo">
                <span class="logo-mark">Loona</span>
            </div>
            <h1>Publicar produto</h1>

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
                    <label for="titulo">Titulo</label>
                    <input type="text" id="titulo" name="titulo" value="<?= esc($titulo) ?>" required>
                </div>
                <div class="form-field">
                    <label for="descricao">Descricao</label>
                    <textarea id="descricao" name="descricao" placeholder="Conta a historia do teu produto..."><?= esc($descricao) ?></textarea>
                </div>
                <div class="form-field">
                    <label for="preco">Preco (€)</label>
                    <input type="text" id="preco" name="preco" value="<?= esc($preco) ?>" placeholder="Ex: 12.50" required>
                </div>
                <div class="form-field">
                    <label for="estado">Estado</label>
                    <select id="estado" name="estado">
                        <option value="usado" <?= $estado === 'usado' ? 'selected' : '' ?>>Usado</option>
                        <option value="novo" <?= $estado === 'novo' ? 'selected' : '' ?>>Novo</option>
                    </select>
                </div>
                <div class="form-field">
                    <label for="categoria">Categoria (opcional)</label>
                    <input type="text" id="categoria" name="categoria" value="<?= esc($categoria) ?>" placeholder="Ex: Sneakers, Vintage">
                </div>
                <div class="form-field">
                    <label for="imagem">URL da imagem (opcional)</label>
                    <input type="url" id="imagem" name="imagem" value="<?= esc($imagem) ?>" placeholder="https://...">
                </div>
            </div>

            <div class="form-actions">
                <button class="btn primary" type="submit">Publicar</button>
                <a class="btn ghost" href="/PAP/index.php">Cancelar</a>
            </div>
            <p class="form-help">Depois de publicares, o produto aparece logo na pagina inicial.</p>
        </form>
    </div>
</body>
</html>
