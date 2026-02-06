<?php
declare(strict_types=1);

session_start();

require_once __DIR__ . '/config/db.php';

function esc(string $value): string
{
    return htmlspecialchars($value, ENT_QUOTES | ENT_SUBSTITUTE, 'UTF-8');
}

$categories = [];
$products = [];
$trendings = [];
$sellers = [];
$user = null;

if (isset($_SESSION['user_id']) && $db) {
    $stmt = $db->prepare('SELECT id_utilizador, nome, email, foto_perfil FROM utilizadores WHERE id_utilizador = ? LIMIT 1');
    $stmt->bind_param('i', $_SESSION['user_id']);
    $stmt->execute();
    $user = $stmt->get_result()->fetch_assoc() ?: null;
}

if ($db) {
    $catResult = $db->query('SELECT id_categoria, nome FROM categorias ORDER BY nome ASC LIMIT 12');
    if ($catResult) {
        $categories = $catResult->fetch_all(MYSQLI_ASSOC);
    }

    $excludeUser = '';
    if (!empty($_SESSION['user_id'])) {
        $excludeUser = ' AND p.id_utilizador <> ' . (int) $_SESSION['user_id'];
    }

    $productSql = "
        SELECT
            p.id_produto,
            p.titulo,
            p.preco,
            p.estado,
            p.status,
            p.criado_em,
            u.nome AS vendedor_nome,
            u.foto_perfil,
            img.url_imagem
        FROM produtos p
        JOIN utilizadores u ON u.id_utilizador = p.id_utilizador
        LEFT JOIN (
            SELECT id_produto, MIN(url_imagem) AS url_imagem
            FROM imagens_produto
            GROUP BY id_produto
        ) img ON img.id_produto = p.id_produto
        WHERE p.status = 'ativo'{$excludeUser}
        ORDER BY p.criado_em DESC
        LIMIT 12
    ";

    $productResult = $db->query($productSql);
    if ($productResult) {
        $products = $productResult->fetch_all(MYSQLI_ASSOC);
    }

    $trendResult = $db->query($productSql);
    if ($trendResult) {
        $trendings = $trendResult->fetch_all(MYSQLI_ASSOC);
    }

    $sellerSql = "
        SELECT
            u.id_utilizador,
            u.nome,
            u.foto_perfil,
            COUNT(p.id_produto) AS total_produtos
        FROM utilizadores u
        LEFT JOIN produtos p
            ON p.id_utilizador = u.id_utilizador
            AND p.status = 'ativo'
        GROUP BY u.id_utilizador
        ORDER BY total_produtos DESC, u.nome ASC
        LIMIT 6
    ";
    $sellerResult = $db->query($sellerSql);
    if ($sellerResult) {
        $sellers = $sellerResult->fetch_all(MYSQLI_ASSOC);
    }
}

// Sem dados falsos: tudo vem da base de dados.

function format_price($value): string
{
    return number_format((float) $value, 2, ',', ' ') . ' €';
}

?>
<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Loona | Marketplace</title>
    <link rel="stylesheet" href="/PAP/assets/css/main.css">
</head>
<body>
    <div class="page">
        <header class="topbar">
            <div class="logo">
                <span class="logo-mark">Loona</span>
            </div>
            <form class="search" method="get" action="#">
                <input type="search" name="q" placeholder="Procura marcas, estilos ou categorias" />
                <button type="submit">Pesquisar</button>
            </form>
            <nav class="topnav">
                <a href="#">Explorar</a>
                <a href="#">Favoritos</a>
                <a href="#">Mensagens</a>
                <?php if ($user) : ?>
                    <a href="/PAP/logout.php">Sair</a>
                <?php else : ?>
                    <a href="/PAP/login.php">Entrar</a>
                <?php endif; ?>
                <a class="cta" href="/PAP/sell.php">Vender</a>
            </nav>
        </header>

        <?php if (!empty($db_error)) : ?>
            <div class="db-warning">
                <strong>Ligacao a base de dados falhou:</strong>
                <span><?= esc($db_error) ?></span>
            </div>
        <?php endif; ?>

        <section class="hero">
            <div class="hero-main">
                <div class="hero-tag">Items reais de outros utilizadores</div>
                <h1>Descobre pecas unicas com personalidade.</h1>
                <p>Um marketplace feito por utilizadores reais: encontra estilos autenticos, boas oportunidades e vendedores da tua zona.</p>
                <div class="hero-actions">
                    <a class="btn primary" href="#produtos">Explorar agora</a>
                    <a class="btn ghost" href="/PAP/signup.php">Criar conta</a>
                </div>
                <div class="taste-row">
                    <span class="pill">Minimal</span>
                    <span class="pill">Vintage 90s</span>
                    <span class="pill">Streetwear</span>
                    <span class="pill">Techwear</span>
                </div>
                <div class="hero-stats">
                    <div>
                        <strong>+4.8k</strong>
                        <span>novas pecas esta semana</span>
                    </div>
                    <div>
                        <strong>98%</strong>
                        <span>avaliacoes positivas</span>
                    </div>
                    <div>
                        <strong>24h</strong>
                        <span>tempo medio de venda</span>
                    </div>
                </div>
            </div>
            <aside class="hero-panel">
                <div class="profile-card">
                    <?php if ($user) : ?>
                        <div class="profile-top">
                            <div class="avatar">
                                <?php if (!empty($user['foto_perfil'])) : ?>
                                    <img src="<?= esc($user['foto_perfil']) ?>" alt="Foto de <?= esc($user['nome']) ?>">
                                <?php else : ?>
                                    <span><?= esc(strtoupper(substr($user['nome'], 0, 2))) ?></span>
                                <?php endif; ?>
                            </div>
                            <div>
                                <h3>Bem-vindo, <?= esc($user['nome']) ?></h3>
                                <p><?= esc($user['email']) ?></p>
                            </div>
                        </div>
                        <div class="profile-actions">
                            <a class="btn primary" href="/PAP/sell.php">Vender rapido</a>
                            <a class="btn ghost" href="/PAP/logout.php">Sair</a>
                        </div>
                    <?php else : ?>
                        <div class="profile-top">
                            <div class="avatar">
                                <span>?</span>
                            </div>
                            <div>
                                <h3>Conta gratuita</h3>
                                <p>Entra para guardar favoritos e vender mais depressa.</p>
                            </div>
                        </div>
                        <div class="profile-actions">
                            <a class="btn primary" href="/PAP/login.php">Entrar</a>
                            <a class="btn ghost" href="/PAP/signup.php">Criar conta</a>
                        </div>
                    <?php endif; ?>
                </div>
                <div class="banner-card">
                    <h4>Vende em minutos</h4>
                    <p>Publica fotos, define preco e recebe mensagens instantaneas.</p>
                    <a class="btn slim" href="/PAP/sell.php">Comecar a vender</a>
                </div>
            </aside>
        </section>

        <section class="section categories">
            <div class="section-header">
                <h2>Categorias em destaque</h2>
                <a href="#">Ver todas</a>
            </div>
            <div class="category-grid">
                <?php if ($categories) : ?>
                    <?php foreach ($categories as $category) : ?>
                        <div class="category-card">
                            <div class="category-icon">#</div>
                            <span><?= esc($category['nome']) ?></span>
                        </div>
                    <?php endforeach; ?>
                <?php else : ?>
                    <div class="empty-state">
                        <h4>Ainda nao ha categorias</h4>
                        <p>Quando os utilizadores publicarem produtos, as categorias vao aparecer aqui.</p>
                    </div>
                <?php endif; ?>
            </div>
        </section>

        <section class="section" id="produtos">
            <div class="section-header">
                <h2>Para ti agora</h2>
                <a href="#">Personalizar</a>
            </div>
            <div class="product-grid">
                <?php if ($products) : ?>
                    <?php foreach ($products as $product) : ?>
                        <article class="product-card">
                            <div class="product-image">
                                <?php if (!empty($product['url_imagem'])) : ?>
                                    <img src="<?= esc($product['url_imagem']) ?>" alt="<?= esc($product['titulo']) ?>">
                                <?php else : ?>
                                    <div class="placeholder">Foto</div>
                                <?php endif; ?>
                                <span class="badge"><?= esc($product['estado'] ?? 'usado') ?></span>
                            </div>
                            <div class="product-info">
                                <h3><?= esc($product['titulo']) ?></h3>
                                <div class="product-meta">
                                    <span class="price"><?= format_price($product['preco']) ?></span>
                                    <span class="seller">Vendido por <?= esc($product['vendedor_nome'] ?? 'Vendedor') ?></span>
                                </div>
                                <div class="product-seller">
                                    <div class="seller-avatar">
                                        <?php if (!empty($product['foto_perfil'])) : ?>
                                            <img src="<?= esc($product['foto_perfil']) ?>" alt="Foto de <?= esc($product['vendedor_nome'] ?? 'Vendedor') ?>">
                                        <?php else : ?>
                                            <span><?= esc(strtoupper(substr($product['vendedor_nome'] ?? 'V', 0, 1))) ?></span>
                                        <?php endif; ?>
                                    </div>
                                    <div>
                                        <strong><?= esc($product['vendedor_nome'] ?? 'Vendedor') ?></strong>
                                        <span class="seller-tag">Armario verificado</span>
                                    </div>
                                </div>
                            </div>
                        </article>
                    <?php endforeach; ?>
                <?php else : ?>
                    <div class="empty-state">
                        <h4>Sem produtos por agora</h4>
                        <p>Quando um utilizador publicar um produto, ele aparece aqui. Queres ser o primeiro?</p>
                        <a class="btn primary" href="/PAP/sell.php">Publicar produto</a>
                    </div>
                <?php endif; ?>
            </div>
        </section>

        <section class="section sellers">
            <div class="section-header">
                <h2>Vendedores em destaque</h2>
                <a href="#">Ver todos</a>
            </div>
            <div class="seller-grid">
                <?php if ($sellers) : ?>
                    <?php foreach ($sellers as $seller) : ?>
                        <article class="seller-card">
                            <div class="seller-hero">
                                <div class="seller-avatar large">
                                    <?php if (!empty($seller['foto_perfil'])) : ?>
                                        <img src="<?= esc($seller['foto_perfil']) ?>" alt="Foto de <?= esc($seller['nome']) ?>">
                                    <?php else : ?>
                                        <span><?= esc(strtoupper(substr($seller['nome'], 0, 2))) ?></span>
                                    <?php endif; ?>
                                </div>
                                <div>
                                    <h3><?= esc($seller['nome']) ?></h3>
                                    <p><?= (int) $seller['total_produtos'] ?> artigos ativos</p>
                                </div>
                            </div>
                            <div class="seller-actions">
                                <a class="btn ghost" href="#">Ver armario</a>
                                <a class="btn primary" href="#">Mensagem</a>
                            </div>
                        </article>
                    <?php endforeach; ?>
                <?php else : ?>
                    <div class="empty-state">
                        <h4>Sem vendedores ainda</h4>
                        <p>Cria a tua conta e comeca a vender.</p>
                        <a class="btn primary" href="/PAP/signup.php">Criar conta</a>
                    </div>
                <?php endif; ?>
            </div>
        </section>

        <section class="section split">
            <div class="split-left">
                <h2>Escolhe, conversa, compra com seguranca.</h2>
                <p>Mensagens integradas, pagamentos protegidos e feedback transparente para criares confianca.</p>
                <div class="steps">
                    <div>
                        <strong>1</strong>
                        <span>Encontra o item perfeito</span>
                    </div>
                    <div>
                        <strong>2</strong>
                        <span>Fala com o vendedor</span>
                    </div>
                    <div>
                        <strong>3</strong>
                        <span>Compra sem stress</span>
                    </div>
                </div>
            </div>
            <div class="split-right">
                <h3>Tendencias de hoje</h3>
                <div class="mini-grid">
                    <?php if ($trendings) : ?>
                        <?php foreach (array_slice($trendings, 0, 4) as $product) : ?>
                            <div class="mini-card">
                                <div class="mini-image">
                                    <?php if (!empty($product['url_imagem'])) : ?>
                                        <img src="<?= esc($product['url_imagem']) ?>" alt="<?= esc($product['titulo']) ?>">
                                    <?php else : ?>
                                        <div class="placeholder">Imagem</div>
                                    <?php endif; ?>
                                </div>
                                <div>
                                    <span><?= esc($product['titulo']) ?></span>
                                    <strong><?= format_price($product['preco']) ?></strong>
                                </div>
                            </div>
                        <?php endforeach; ?>
                    <?php else : ?>
                        <div class="empty-state compact">
                            <h4>Sem tendencias ainda</h4>
                            <p>Assim que houver vendas, vao aparecer aqui.</p>
                        </div>
                    <?php endif; ?>
                </div>
            </div>
        </section>

        <section class="section cta-section">
            <div>
                <h2>Pronto para vender o que ja nao usas?</h2>
                <p>Cria o teu armario digital em menos de 2 minutos.</p>
            </div>
            <a class="btn primary" href="/PAP/sell.php">Comecar agora</a>
        </section>

        <footer class="footer">
            <div>
                <strong>Loona</strong>
                <p>Marketplace escolar inspirado no melhor de comunidades reais.</p>
            </div>
            <div class="footer-links">
                <a href="#">Sobre</a>
                <a href="#">Ajuda</a>
                <a href="#">Seguranca</a>
            </div>
        </footer>
    </div>
</body>
</html>
