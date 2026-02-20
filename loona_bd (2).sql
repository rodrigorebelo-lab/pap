-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Tempo de geração: 19-Fev-2026 às 11:55
-- Versão do servidor: 10.4.32-MariaDB
-- versão do PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `loona_bd`
--

-- --------------------------------------------------------

--
-- Estrutura da tabela `audit_log`
--

CREATE TABLE `audit_log` (
  `id_log` bigint(20) UNSIGNED NOT NULL,
  `id_utilizador` bigint(20) UNSIGNED DEFAULT NULL,
  `evento` varchar(80) NOT NULL,
  `detalhes` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`detalhes`)),
  `ip` varchar(64) DEFAULT NULL,
  `criado_em` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `avaliacoes`
--

CREATE TABLE `avaliacoes` (
  `id_avaliacao` bigint(20) UNSIGNED NOT NULL,
  `id_encomenda` bigint(20) UNSIGNED DEFAULT NULL,
  `id_avaliador` bigint(20) UNSIGNED NOT NULL,
  `id_avaliado` bigint(20) UNSIGNED NOT NULL,
  `estrelas` tinyint(3) UNSIGNED NOT NULL,
  `comentario` varchar(500) DEFAULT NULL,
  `criado_em` datetime NOT NULL DEFAULT current_timestamp()
) ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `badges`
--

CREATE TABLE `badges` (
  `id_badge` bigint(20) UNSIGNED NOT NULL,
  `nome` varchar(80) NOT NULL,
  `descricao` varchar(255) DEFAULT NULL,
  `icon_url` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `carrinhos`
--

CREATE TABLE `carrinhos` (
  `id_carrinho` bigint(20) UNSIGNED NOT NULL,
  `id_utilizador` bigint(20) UNSIGNED NOT NULL,
  `atualizado_em` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `carrinho_itens`
--

CREATE TABLE `carrinho_itens` (
  `id_item` bigint(20) UNSIGNED NOT NULL,
  `id_carrinho` bigint(20) UNSIGNED NOT NULL,
  `id_produto` bigint(20) UNSIGNED NOT NULL,
  `id_variacao` bigint(20) UNSIGNED DEFAULT NULL,
  `quantidade` int(10) UNSIGNED NOT NULL DEFAULT 1,
  `preco_snapshot` decimal(10,2) NOT NULL,
  `criado_em` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `categorias`
--

CREATE TABLE `categorias` (
  `id_categoria` bigint(20) UNSIGNED NOT NULL,
  `id_parent` bigint(20) UNSIGNED DEFAULT NULL,
  `nome` varchar(120) NOT NULL,
  `slug` varchar(140) NOT NULL,
  `ativa` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `conversas`
--

CREATE TABLE `conversas` (
  `id_conversa` bigint(20) UNSIGNED NOT NULL,
  `id_utilizador1` bigint(20) UNSIGNED NOT NULL,
  `id_utilizador2` bigint(20) UNSIGNED NOT NULL,
  `id_produto` bigint(20) UNSIGNED DEFAULT NULL,
  `ultima_mensagem_em` datetime DEFAULT NULL,
  `criado_em` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `denuncias`
--

CREATE TABLE `denuncias` (
  `id_denuncia` bigint(20) UNSIGNED NOT NULL,
  `id_denunciante` bigint(20) UNSIGNED NOT NULL,
  `alvo_tipo` enum('utilizador','produto','mensagem') NOT NULL,
  `alvo_id` bigint(20) UNSIGNED NOT NULL,
  `motivo` enum('spam','burla','conteudo','assédio','ilegal','outro') NOT NULL,
  `descricao` varchar(800) DEFAULT NULL,
  `estado` enum('aberta','em_analise','resolvida','rejeitada') NOT NULL DEFAULT 'aberta',
  `criado_em` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `encomendas`
--

CREATE TABLE `encomendas` (
  `id_encomenda` bigint(20) UNSIGNED NOT NULL,
  `id_comprador` bigint(20) UNSIGNED NOT NULL,
  `id_endereco_envio` bigint(20) UNSIGNED DEFAULT NULL,
  `total` decimal(10,2) NOT NULL DEFAULT 0.00,
  `moeda` char(3) NOT NULL DEFAULT 'EUR',
  `estado` enum('criada','a_pagar','paga','em_preparacao','enviada','concluida','cancelada','reembolsada','em_disputa') NOT NULL DEFAULT 'criada',
  `criado_em` datetime NOT NULL DEFAULT current_timestamp(),
  `atualizado_em` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `encomenda_itens`
--

CREATE TABLE `encomenda_itens` (
  `id_item` bigint(20) UNSIGNED NOT NULL,
  `id_encomenda` bigint(20) UNSIGNED NOT NULL,
  `id_produto` bigint(20) UNSIGNED NOT NULL,
  `id_vendedor` bigint(20) UNSIGNED NOT NULL,
  `id_variacao` bigint(20) UNSIGNED DEFAULT NULL,
  `titulo_snapshot` varchar(160) NOT NULL,
  `preco_unitario` decimal(10,2) NOT NULL,
  `quantidade` int(10) UNSIGNED NOT NULL DEFAULT 1,
  `subtotal` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `enderecos`
--

CREATE TABLE `enderecos` (
  `id_endereco` bigint(20) UNSIGNED NOT NULL,
  `id_utilizador` bigint(20) UNSIGNED NOT NULL,
  `nome_destinatario` varchar(120) NOT NULL,
  `telemovel` varchar(30) DEFAULT NULL,
  `linha1` varchar(190) NOT NULL,
  `linha2` varchar(190) DEFAULT NULL,
  `cidade` varchar(120) NOT NULL,
  `distrito` varchar(120) DEFAULT NULL,
  `codigo_postal` varchar(20) NOT NULL,
  `pais` varchar(2) NOT NULL DEFAULT 'PT',
  `tipo` enum('envio','faturacao','ambos') NOT NULL DEFAULT 'ambos',
  `principal` tinyint(1) NOT NULL DEFAULT 0,
  `criado_em` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `envios`
--

CREATE TABLE `envios` (
  `id_envio` bigint(20) UNSIGNED NOT NULL,
  `id_encomenda` bigint(20) UNSIGNED NOT NULL,
  `transportadora` varchar(80) DEFAULT NULL,
  `tracking_code` varchar(120) DEFAULT NULL,
  `estado` enum('pendente','etiqueta_criada','em_transito','entregue','devolvido') NOT NULL DEFAULT 'pendente',
  `enviado_em` datetime DEFAULT NULL,
  `entregue_em` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `favoritos`
--

CREATE TABLE `favoritos` (
  `id_utilizador` bigint(20) UNSIGNED NOT NULL,
  `id_produto` bigint(20) UNSIGNED NOT NULL,
  `criado_em` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `gamificacao_perfil`
--

CREATE TABLE `gamificacao_perfil` (
  `id_utilizador` bigint(20) UNSIGNED NOT NULL,
  `xp` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `nivel` int(10) UNSIGNED NOT NULL DEFAULT 1,
  `streak_dias` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `atualizado_em` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `marcas`
--

CREATE TABLE `marcas` (
  `id_marca` bigint(20) UNSIGNED NOT NULL,
  `nome` varchar(120) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `mensagem_anexos`
--

CREATE TABLE `mensagem_anexos` (
  `id_anexo` bigint(20) UNSIGNED NOT NULL,
  `id_mensagem` bigint(20) UNSIGNED NOT NULL,
  `url` varchar(255) NOT NULL,
  `mime` varchar(80) DEFAULT NULL,
  `tamanho_bytes` bigint(20) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `mensagem_lidas`
--

CREATE TABLE `mensagem_lidas` (
  `id_mensagem` bigint(20) UNSIGNED NOT NULL,
  `id_utilizador` bigint(20) UNSIGNED NOT NULL,
  `lida_em` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `mensagens`
--

CREATE TABLE `mensagens` (
  `id_mensagem` bigint(20) UNSIGNED NOT NULL,
  `id_conversa` bigint(20) UNSIGNED NOT NULL,
  `id_remetente` bigint(20) UNSIGNED NOT NULL,
  `tipo` enum('texto','imagem','ficheiro','sistema') NOT NULL DEFAULT 'texto',
  `mensagem` text DEFAULT NULL,
  `criado_em` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `moderacao_acoes`
--

CREATE TABLE `moderacao_acoes` (
  `id_acao` bigint(20) UNSIGNED NOT NULL,
  `id_moderador` bigint(20) UNSIGNED NOT NULL,
  `acao` enum('suspender_conta','banir_conta','remover_produto','apagar_mensagem','warning') NOT NULL,
  `alvo_tipo` enum('utilizador','produto','mensagem') NOT NULL,
  `alvo_id` bigint(20) UNSIGNED NOT NULL,
  `motivo` varchar(255) DEFAULT NULL,
  `criado_em` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `notificacoes`
--

CREATE TABLE `notificacoes` (
  `id_notificacao` bigint(20) UNSIGNED NOT NULL,
  `id_utilizador` bigint(20) UNSIGNED NOT NULL,
  `tipo` enum('mensagem','produto','encomenda','pagamento','sistema','avaliacao','denuncia') NOT NULL,
  `texto` varchar(255) NOT NULL,
  `lida` tinyint(1) NOT NULL DEFAULT 0,
  `id_conversa` bigint(20) UNSIGNED DEFAULT NULL,
  `id_produto` bigint(20) UNSIGNED DEFAULT NULL,
  `id_encomenda` bigint(20) UNSIGNED DEFAULT NULL,
  `criado_em` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `pagamentos`
--

CREATE TABLE `pagamentos` (
  `id_pagamento` bigint(20) UNSIGNED NOT NULL,
  `id_encomenda` bigint(20) UNSIGNED NOT NULL,
  `provider` enum('mbway','multibanco','card','paypal','stripe','cash') NOT NULL,
  `referencia_externa` varchar(120) DEFAULT NULL,
  `valor` decimal(10,2) NOT NULL,
  `moeda` char(3) NOT NULL DEFAULT 'EUR',
  `estado` enum('pendente','autorizado','confirmado','falhado','cancelado','reembolsado') NOT NULL DEFAULT 'pendente',
  `criado_em` datetime NOT NULL DEFAULT current_timestamp(),
  `confirmado_em` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `produtos`
--

CREATE TABLE `produtos` (
  `id_produto` bigint(20) UNSIGNED NOT NULL,
  `id_vendedor` bigint(20) UNSIGNED NOT NULL,
  `id_categoria` bigint(20) UNSIGNED NOT NULL,
  `id_marca` bigint(20) UNSIGNED DEFAULT NULL,
  `titulo` varchar(160) NOT NULL,
  `descricao` text DEFAULT NULL,
  `condicao` enum('novo','como_novo','bom','razoavel','para_pecas') NOT NULL DEFAULT 'bom',
  `tipo` enum('novo','usado') NOT NULL DEFAULT 'usado',
  `preco` decimal(10,2) NOT NULL,
  `moeda` char(3) NOT NULL DEFAULT 'EUR',
  `negociavel` tinyint(1) NOT NULL DEFAULT 0,
  `entrega` enum('envio','mao','ambos') NOT NULL DEFAULT 'ambos',
  `localizacao` varchar(120) DEFAULT NULL,
  `estado_anuncio` enum('rascunho','ativo','pausado','vendido','removido') NOT NULL DEFAULT 'ativo',
  `visualizacoes` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `criado_em` datetime NOT NULL DEFAULT current_timestamp(),
  `atualizado_em` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `produto_imagens`
--

CREATE TABLE `produto_imagens` (
  `id_imagem` bigint(20) UNSIGNED NOT NULL,
  `id_produto` bigint(20) UNSIGNED NOT NULL,
  `url_imagem` varchar(255) NOT NULL,
  `ordem` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `criado_em` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `produto_tags`
--

CREATE TABLE `produto_tags` (
  `id_produto` bigint(20) UNSIGNED NOT NULL,
  `id_tag` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `produto_variacoes`
--

CREATE TABLE `produto_variacoes` (
  `id_variacao` bigint(20) UNSIGNED NOT NULL,
  `id_produto` bigint(20) UNSIGNED NOT NULL,
  `sku` varchar(80) DEFAULT NULL,
  `nome` varchar(120) NOT NULL,
  `stock` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `preco_override` decimal(10,2) DEFAULT NULL,
  `ativo` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `reembolsos`
--

CREATE TABLE `reembolsos` (
  `id_reembolso` bigint(20) UNSIGNED NOT NULL,
  `id_pagamento` bigint(20) UNSIGNED NOT NULL,
  `valor` decimal(10,2) NOT NULL,
  `motivo` varchar(255) DEFAULT NULL,
  `estado` enum('pedido','aprovado','recusado','processado') NOT NULL DEFAULT 'pedido',
  `criado_em` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `roles`
--

CREATE TABLE `roles` (
  `id_role` tinyint(3) UNSIGNED NOT NULL,
  `nome` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Extraindo dados da tabela `roles`
--

INSERT INTO `roles` (`id_role`, `nome`) VALUES
(3, 'admin'),
(2, 'moderator'),
(1, 'user');

-- --------------------------------------------------------

--
-- Estrutura da tabela `sessoes`
--

CREATE TABLE `sessoes` (
  `id_sessao` bigint(20) UNSIGNED NOT NULL,
  `id_utilizador` bigint(20) UNSIGNED NOT NULL,
  `refresh_token_hash` varchar(255) NOT NULL,
  `user_agent` varchar(255) DEFAULT NULL,
  `ip` varchar(64) DEFAULT NULL,
  `criado_em` datetime NOT NULL DEFAULT current_timestamp(),
  `expira_em` datetime NOT NULL,
  `revogado_em` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `tags`
--

CREATE TABLE `tags` (
  `id_tag` bigint(20) UNSIGNED NOT NULL,
  `nome` varchar(60) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `transacoes_vendedor`
--

CREATE TABLE `transacoes_vendedor` (
  `id_transacao` bigint(20) UNSIGNED NOT NULL,
  `id_encomenda` bigint(20) UNSIGNED NOT NULL,
  `id_vendedor` bigint(20) UNSIGNED NOT NULL,
  `valor_bruto` decimal(10,2) NOT NULL,
  `taxa_plataforma` decimal(10,2) NOT NULL DEFAULT 0.00,
  `valor_liquido` decimal(10,2) NOT NULL,
  `estado` enum('pendente','disponivel','paga','retida','reembolsada') NOT NULL DEFAULT 'pendente',
  `criado_em` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `utilizadores`
--

CREATE TABLE `utilizadores` (
  `id_utilizador` bigint(20) UNSIGNED NOT NULL,
  `id_role` tinyint(3) UNSIGNED NOT NULL DEFAULT 1,
  `nome` varchar(120) NOT NULL,
  `username` varchar(50) DEFAULT NULL,
  `email` varchar(190) NOT NULL,
  `email_verificado` tinyint(1) NOT NULL DEFAULT 0,
  `telemovel` varchar(30) DEFAULT NULL,
  `telemovel_verificado` tinyint(1) NOT NULL DEFAULT 0,
  `palavra_passe_hash` varchar(255) DEFAULT NULL,
  `foto_perfil` varchar(255) DEFAULT NULL,
  `bio` varchar(500) DEFAULT NULL,
  `dois_fatores_ativo` tinyint(1) NOT NULL DEFAULT 0,
  `dois_fatores_metodo` enum('app','sms','email') DEFAULT NULL,
  `estado_conta` enum('ativa','suspensa','banida','apagada') NOT NULL DEFAULT 'ativa',
  `criado_em` datetime NOT NULL DEFAULT current_timestamp(),
  `atualizado_em` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `utilizador_badges`
--

CREATE TABLE `utilizador_badges` (
  `id_utilizador` bigint(20) UNSIGNED NOT NULL,
  `id_badge` bigint(20) UNSIGNED NOT NULL,
  `ganho_em` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `utilizador_seguranca`
--

CREATE TABLE `utilizador_seguranca` (
  `id_utilizador` bigint(20) UNSIGNED NOT NULL,
  `codigo_reset_hash` varchar(255) DEFAULT NULL,
  `reset_expira_em` datetime DEFAULT NULL,
  `codigo_2fa_hash` varchar(255) DEFAULT NULL,
  `codigo_2fa_expira_em` datetime DEFAULT NULL,
  `tentativas_login` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `bloqueado_ate` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Índices para tabelas despejadas
--

--
-- Índices para tabela `audit_log`
--
ALTER TABLE `audit_log`
  ADD PRIMARY KEY (`id_log`),
  ADD KEY `fk_audit_user` (`id_utilizador`),
  ADD KEY `idx_audit_evento` (`evento`),
  ADD KEY `idx_audit_criado` (`criado_em`);

--
-- Índices para tabela `avaliacoes`
--
ALTER TABLE `avaliacoes`
  ADD PRIMARY KEY (`id_avaliacao`),
  ADD KEY `fk_av_enc` (`id_encomenda`),
  ADD KEY `fk_av_avaliador` (`id_avaliador`),
  ADD KEY `idx_av_avaliado` (`id_avaliado`),
  ADD KEY `idx_av_estrelas` (`estrelas`);

--
-- Índices para tabela `badges`
--
ALTER TABLE `badges`
  ADD PRIMARY KEY (`id_badge`),
  ADD UNIQUE KEY `nome` (`nome`);

--
-- Índices para tabela `carrinhos`
--
ALTER TABLE `carrinhos`
  ADD PRIMARY KEY (`id_carrinho`),
  ADD UNIQUE KEY `uk_carrinho_user` (`id_utilizador`);

--
-- Índices para tabela `carrinho_itens`
--
ALTER TABLE `carrinho_itens`
  ADD PRIMARY KEY (`id_item`),
  ADD KEY `fk_ci_variacao` (`id_variacao`),
  ADD KEY `idx_ci_carrinho` (`id_carrinho`),
  ADD KEY `idx_ci_produto` (`id_produto`);

--
-- Índices para tabela `categorias`
--
ALTER TABLE `categorias`
  ADD PRIMARY KEY (`id_categoria`),
  ADD UNIQUE KEY `uk_categorias_slug` (`slug`),
  ADD KEY `idx_categorias_parent` (`id_parent`);

--
-- Índices para tabela `conversas`
--
ALTER TABLE `conversas`
  ADD PRIMARY KEY (`id_conversa`),
  ADD KEY `fk_conv_u2` (`id_utilizador2`),
  ADD KEY `idx_conv_users` (`id_utilizador1`,`id_utilizador2`),
  ADD KEY `idx_conv_prod` (`id_produto`);

--
-- Índices para tabela `denuncias`
--
ALTER TABLE `denuncias`
  ADD PRIMARY KEY (`id_denuncia`),
  ADD KEY `fk_den_denunciante` (`id_denunciante`),
  ADD KEY `idx_den_estado` (`estado`),
  ADD KEY `idx_den_alvo` (`alvo_tipo`,`alvo_id`);

--
-- Índices para tabela `encomendas`
--
ALTER TABLE `encomendas`
  ADD PRIMARY KEY (`id_encomenda`),
  ADD KEY `fk_encomendas_endereco` (`id_endereco_envio`),
  ADD KEY `idx_encomendas_comprador` (`id_comprador`),
  ADD KEY `idx_encomendas_estado` (`estado`);

--
-- Índices para tabela `encomenda_itens`
--
ALTER TABLE `encomenda_itens`
  ADD PRIMARY KEY (`id_item`),
  ADD KEY `fk_ei_produto` (`id_produto`),
  ADD KEY `fk_ei_variacao` (`id_variacao`),
  ADD KEY `idx_ei_encomenda` (`id_encomenda`),
  ADD KEY `idx_ei_vendedor` (`id_vendedor`);

--
-- Índices para tabela `enderecos`
--
ALTER TABLE `enderecos`
  ADD PRIMARY KEY (`id_endereco`),
  ADD KEY `idx_enderecos_user` (`id_utilizador`),
  ADD KEY `idx_enderecos_principal` (`principal`);

--
-- Índices para tabela `envios`
--
ALTER TABLE `envios`
  ADD PRIMARY KEY (`id_envio`),
  ADD KEY `idx_envios_estado` (`estado`),
  ADD KEY `idx_envios_encomenda` (`id_encomenda`);

--
-- Índices para tabela `favoritos`
--
ALTER TABLE `favoritos`
  ADD PRIMARY KEY (`id_utilizador`,`id_produto`),
  ADD KEY `fk_fav_prod` (`id_produto`);

--
-- Índices para tabela `gamificacao_perfil`
--
ALTER TABLE `gamificacao_perfil`
  ADD PRIMARY KEY (`id_utilizador`);

--
-- Índices para tabela `marcas`
--
ALTER TABLE `marcas`
  ADD PRIMARY KEY (`id_marca`),
  ADD UNIQUE KEY `nome` (`nome`);

--
-- Índices para tabela `mensagem_anexos`
--
ALTER TABLE `mensagem_anexos`
  ADD PRIMARY KEY (`id_anexo`),
  ADD KEY `idx_anexo_msg` (`id_mensagem`);

--
-- Índices para tabela `mensagem_lidas`
--
ALTER TABLE `mensagem_lidas`
  ADD PRIMARY KEY (`id_mensagem`,`id_utilizador`),
  ADD KEY `fk_ml_user` (`id_utilizador`);

--
-- Índices para tabela `mensagens`
--
ALTER TABLE `mensagens`
  ADD PRIMARY KEY (`id_mensagem`),
  ADD KEY `fk_msg_remetente` (`id_remetente`),
  ADD KEY `idx_msg_conversa` (`id_conversa`),
  ADD KEY `idx_msg_criado` (`criado_em`);

--
-- Índices para tabela `moderacao_acoes`
--
ALTER TABLE `moderacao_acoes`
  ADD PRIMARY KEY (`id_acao`),
  ADD KEY `fk_mod_moderador` (`id_moderador`),
  ADD KEY `idx_mod_alvo` (`alvo_tipo`,`alvo_id`);

--
-- Índices para tabela `notificacoes`
--
ALTER TABLE `notificacoes`
  ADD PRIMARY KEY (`id_notificacao`),
  ADD KEY `fk_not_conv` (`id_conversa`),
  ADD KEY `fk_not_prod` (`id_produto`),
  ADD KEY `fk_not_enc` (`id_encomenda`),
  ADD KEY `idx_not_user` (`id_utilizador`),
  ADD KEY `idx_not_lida` (`lida`),
  ADD KEY `idx_not_tipo` (`tipo`);

--
-- Índices para tabela `pagamentos`
--
ALTER TABLE `pagamentos`
  ADD PRIMARY KEY (`id_pagamento`),
  ADD KEY `idx_pagamentos_encomenda` (`id_encomenda`),
  ADD KEY `idx_pagamentos_estado` (`estado`);

--
-- Índices para tabela `produtos`
--
ALTER TABLE `produtos`
  ADD PRIMARY KEY (`id_produto`),
  ADD KEY `fk_produtos_marca` (`id_marca`),
  ADD KEY `idx_produtos_categoria` (`id_categoria`),
  ADD KEY `idx_produtos_vendedor` (`id_vendedor`),
  ADD KEY `idx_produtos_estado` (`estado_anuncio`),
  ADD KEY `idx_produtos_preco` (`preco`);

--
-- Índices para tabela `produto_imagens`
--
ALTER TABLE `produto_imagens`
  ADD PRIMARY KEY (`id_imagem`),
  ADD KEY `idx_imagens_produto` (`id_produto`),
  ADD KEY `idx_imagens_ordem` (`ordem`);

--
-- Índices para tabela `produto_tags`
--
ALTER TABLE `produto_tags`
  ADD PRIMARY KEY (`id_produto`,`id_tag`),
  ADD KEY `fk_pt_tag` (`id_tag`);

--
-- Índices para tabela `produto_variacoes`
--
ALTER TABLE `produto_variacoes`
  ADD PRIMARY KEY (`id_variacao`),
  ADD KEY `idx_variacoes_produto` (`id_produto`),
  ADD KEY `idx_variacoes_stock` (`stock`);

--
-- Índices para tabela `reembolsos`
--
ALTER TABLE `reembolsos`
  ADD PRIMARY KEY (`id_reembolso`),
  ADD KEY `fk_reembolso_pagamento` (`id_pagamento`),
  ADD KEY `idx_reembolsos_estado` (`estado`);

--
-- Índices para tabela `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id_role`),
  ADD UNIQUE KEY `nome` (`nome`);

--
-- Índices para tabela `sessoes`
--
ALTER TABLE `sessoes`
  ADD PRIMARY KEY (`id_sessao`),
  ADD KEY `idx_sessoes_user` (`id_utilizador`),
  ADD KEY `idx_sessoes_expira` (`expira_em`);

--
-- Índices para tabela `tags`
--
ALTER TABLE `tags`
  ADD PRIMARY KEY (`id_tag`),
  ADD UNIQUE KEY `nome` (`nome`);

--
-- Índices para tabela `transacoes_vendedor`
--
ALTER TABLE `transacoes_vendedor`
  ADD PRIMARY KEY (`id_transacao`),
  ADD KEY `fk_tv_encomenda` (`id_encomenda`),
  ADD KEY `idx_tv_vendedor` (`id_vendedor`),
  ADD KEY `idx_tv_estado` (`estado`);

--
-- Índices para tabela `utilizadores`
--
ALTER TABLE `utilizadores`
  ADD PRIMARY KEY (`id_utilizador`),
  ADD UNIQUE KEY `uk_utilizadores_email` (`email`),
  ADD UNIQUE KEY `uk_utilizadores_username` (`username`),
  ADD KEY `fk_utilizadores_role` (`id_role`),
  ADD KEY `idx_utilizadores_estado` (`estado_conta`);

--
-- Índices para tabela `utilizador_badges`
--
ALTER TABLE `utilizador_badges`
  ADD PRIMARY KEY (`id_utilizador`,`id_badge`),
  ADD KEY `fk_ub_badge` (`id_badge`);

--
-- Índices para tabela `utilizador_seguranca`
--
ALTER TABLE `utilizador_seguranca`
  ADD PRIMARY KEY (`id_utilizador`);

--
-- AUTO_INCREMENT de tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `audit_log`
--
ALTER TABLE `audit_log`
  MODIFY `id_log` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `avaliacoes`
--
ALTER TABLE `avaliacoes`
  MODIFY `id_avaliacao` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `badges`
--
ALTER TABLE `badges`
  MODIFY `id_badge` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `carrinhos`
--
ALTER TABLE `carrinhos`
  MODIFY `id_carrinho` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `carrinho_itens`
--
ALTER TABLE `carrinho_itens`
  MODIFY `id_item` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `categorias`
--
ALTER TABLE `categorias`
  MODIFY `id_categoria` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `conversas`
--
ALTER TABLE `conversas`
  MODIFY `id_conversa` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `denuncias`
--
ALTER TABLE `denuncias`
  MODIFY `id_denuncia` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `encomendas`
--
ALTER TABLE `encomendas`
  MODIFY `id_encomenda` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `encomenda_itens`
--
ALTER TABLE `encomenda_itens`
  MODIFY `id_item` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `enderecos`
--
ALTER TABLE `enderecos`
  MODIFY `id_endereco` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `envios`
--
ALTER TABLE `envios`
  MODIFY `id_envio` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `marcas`
--
ALTER TABLE `marcas`
  MODIFY `id_marca` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `mensagem_anexos`
--
ALTER TABLE `mensagem_anexos`
  MODIFY `id_anexo` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `mensagens`
--
ALTER TABLE `mensagens`
  MODIFY `id_mensagem` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `moderacao_acoes`
--
ALTER TABLE `moderacao_acoes`
  MODIFY `id_acao` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `notificacoes`
--
ALTER TABLE `notificacoes`
  MODIFY `id_notificacao` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `pagamentos`
--
ALTER TABLE `pagamentos`
  MODIFY `id_pagamento` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `produtos`
--
ALTER TABLE `produtos`
  MODIFY `id_produto` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `produto_imagens`
--
ALTER TABLE `produto_imagens`
  MODIFY `id_imagem` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `produto_variacoes`
--
ALTER TABLE `produto_variacoes`
  MODIFY `id_variacao` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `reembolsos`
--
ALTER TABLE `reembolsos`
  MODIFY `id_reembolso` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `sessoes`
--
ALTER TABLE `sessoes`
  MODIFY `id_sessao` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `tags`
--
ALTER TABLE `tags`
  MODIFY `id_tag` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `transacoes_vendedor`
--
ALTER TABLE `transacoes_vendedor`
  MODIFY `id_transacao` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `utilizadores`
--
ALTER TABLE `utilizadores`
  MODIFY `id_utilizador` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- Restrições para despejos de tabelas
--

--
-- Limitadores para a tabela `audit_log`
--
ALTER TABLE `audit_log`
  ADD CONSTRAINT `fk_audit_user` FOREIGN KEY (`id_utilizador`) REFERENCES `utilizadores` (`id_utilizador`) ON DELETE SET NULL;

--
-- Limitadores para a tabela `avaliacoes`
--
ALTER TABLE `avaliacoes`
  ADD CONSTRAINT `fk_av_avaliado` FOREIGN KEY (`id_avaliado`) REFERENCES `utilizadores` (`id_utilizador`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_av_avaliador` FOREIGN KEY (`id_avaliador`) REFERENCES `utilizadores` (`id_utilizador`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_av_enc` FOREIGN KEY (`id_encomenda`) REFERENCES `encomendas` (`id_encomenda`) ON DELETE SET NULL;

--
-- Limitadores para a tabela `carrinhos`
--
ALTER TABLE `carrinhos`
  ADD CONSTRAINT `fk_carrinho_user` FOREIGN KEY (`id_utilizador`) REFERENCES `utilizadores` (`id_utilizador`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `carrinho_itens`
--
ALTER TABLE `carrinho_itens`
  ADD CONSTRAINT `fk_ci_carrinho` FOREIGN KEY (`id_carrinho`) REFERENCES `carrinhos` (`id_carrinho`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_ci_produto` FOREIGN KEY (`id_produto`) REFERENCES `produtos` (`id_produto`),
  ADD CONSTRAINT `fk_ci_variacao` FOREIGN KEY (`id_variacao`) REFERENCES `produto_variacoes` (`id_variacao`) ON DELETE SET NULL;

--
-- Limitadores para a tabela `categorias`
--
ALTER TABLE `categorias`
  ADD CONSTRAINT `fk_categorias_parent` FOREIGN KEY (`id_parent`) REFERENCES `categorias` (`id_categoria`) ON DELETE SET NULL;

--
-- Limitadores para a tabela `conversas`
--
ALTER TABLE `conversas`
  ADD CONSTRAINT `fk_conv_prod` FOREIGN KEY (`id_produto`) REFERENCES `produtos` (`id_produto`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_conv_u1` FOREIGN KEY (`id_utilizador1`) REFERENCES `utilizadores` (`id_utilizador`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_conv_u2` FOREIGN KEY (`id_utilizador2`) REFERENCES `utilizadores` (`id_utilizador`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `denuncias`
--
ALTER TABLE `denuncias`
  ADD CONSTRAINT `fk_den_denunciante` FOREIGN KEY (`id_denunciante`) REFERENCES `utilizadores` (`id_utilizador`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `encomendas`
--
ALTER TABLE `encomendas`
  ADD CONSTRAINT `fk_encomendas_comprador` FOREIGN KEY (`id_comprador`) REFERENCES `utilizadores` (`id_utilizador`),
  ADD CONSTRAINT `fk_encomendas_endereco` FOREIGN KEY (`id_endereco_envio`) REFERENCES `enderecos` (`id_endereco`) ON DELETE SET NULL;

--
-- Limitadores para a tabela `encomenda_itens`
--
ALTER TABLE `encomenda_itens`
  ADD CONSTRAINT `fk_ei_encomenda` FOREIGN KEY (`id_encomenda`) REFERENCES `encomendas` (`id_encomenda`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_ei_produto` FOREIGN KEY (`id_produto`) REFERENCES `produtos` (`id_produto`),
  ADD CONSTRAINT `fk_ei_variacao` FOREIGN KEY (`id_variacao`) REFERENCES `produto_variacoes` (`id_variacao`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_ei_vendedor` FOREIGN KEY (`id_vendedor`) REFERENCES `utilizadores` (`id_utilizador`);

--
-- Limitadores para a tabela `enderecos`
--
ALTER TABLE `enderecos`
  ADD CONSTRAINT `fk_enderecos_utilizador` FOREIGN KEY (`id_utilizador`) REFERENCES `utilizadores` (`id_utilizador`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `envios`
--
ALTER TABLE `envios`
  ADD CONSTRAINT `fk_envios_encomenda` FOREIGN KEY (`id_encomenda`) REFERENCES `encomendas` (`id_encomenda`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `favoritos`
--
ALTER TABLE `favoritos`
  ADD CONSTRAINT `fk_fav_prod` FOREIGN KEY (`id_produto`) REFERENCES `produtos` (`id_produto`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_fav_user` FOREIGN KEY (`id_utilizador`) REFERENCES `utilizadores` (`id_utilizador`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `gamificacao_perfil`
--
ALTER TABLE `gamificacao_perfil`
  ADD CONSTRAINT `fk_gam_user` FOREIGN KEY (`id_utilizador`) REFERENCES `utilizadores` (`id_utilizador`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `mensagem_anexos`
--
ALTER TABLE `mensagem_anexos`
  ADD CONSTRAINT `fk_anexo_msg` FOREIGN KEY (`id_mensagem`) REFERENCES `mensagens` (`id_mensagem`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `mensagem_lidas`
--
ALTER TABLE `mensagem_lidas`
  ADD CONSTRAINT `fk_ml_msg` FOREIGN KEY (`id_mensagem`) REFERENCES `mensagens` (`id_mensagem`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_ml_user` FOREIGN KEY (`id_utilizador`) REFERENCES `utilizadores` (`id_utilizador`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `mensagens`
--
ALTER TABLE `mensagens`
  ADD CONSTRAINT `fk_msg_conversa` FOREIGN KEY (`id_conversa`) REFERENCES `conversas` (`id_conversa`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_msg_remetente` FOREIGN KEY (`id_remetente`) REFERENCES `utilizadores` (`id_utilizador`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `moderacao_acoes`
--
ALTER TABLE `moderacao_acoes`
  ADD CONSTRAINT `fk_mod_moderador` FOREIGN KEY (`id_moderador`) REFERENCES `utilizadores` (`id_utilizador`);

--
-- Limitadores para a tabela `notificacoes`
--
ALTER TABLE `notificacoes`
  ADD CONSTRAINT `fk_not_conv` FOREIGN KEY (`id_conversa`) REFERENCES `conversas` (`id_conversa`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_not_enc` FOREIGN KEY (`id_encomenda`) REFERENCES `encomendas` (`id_encomenda`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_not_prod` FOREIGN KEY (`id_produto`) REFERENCES `produtos` (`id_produto`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_not_user` FOREIGN KEY (`id_utilizador`) REFERENCES `utilizadores` (`id_utilizador`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `pagamentos`
--
ALTER TABLE `pagamentos`
  ADD CONSTRAINT `fk_pagamentos_encomenda` FOREIGN KEY (`id_encomenda`) REFERENCES `encomendas` (`id_encomenda`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `produtos`
--
ALTER TABLE `produtos`
  ADD CONSTRAINT `fk_produtos_categoria` FOREIGN KEY (`id_categoria`) REFERENCES `categorias` (`id_categoria`),
  ADD CONSTRAINT `fk_produtos_marca` FOREIGN KEY (`id_marca`) REFERENCES `marcas` (`id_marca`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_produtos_vendedor` FOREIGN KEY (`id_vendedor`) REFERENCES `utilizadores` (`id_utilizador`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `produto_imagens`
--
ALTER TABLE `produto_imagens`
  ADD CONSTRAINT `fk_produto_imagens_produto` FOREIGN KEY (`id_produto`) REFERENCES `produtos` (`id_produto`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `produto_tags`
--
ALTER TABLE `produto_tags`
  ADD CONSTRAINT `fk_pt_produto` FOREIGN KEY (`id_produto`) REFERENCES `produtos` (`id_produto`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_pt_tag` FOREIGN KEY (`id_tag`) REFERENCES `tags` (`id_tag`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `produto_variacoes`
--
ALTER TABLE `produto_variacoes`
  ADD CONSTRAINT `fk_variacoes_produto` FOREIGN KEY (`id_produto`) REFERENCES `produtos` (`id_produto`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `reembolsos`
--
ALTER TABLE `reembolsos`
  ADD CONSTRAINT `fk_reembolso_pagamento` FOREIGN KEY (`id_pagamento`) REFERENCES `pagamentos` (`id_pagamento`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `sessoes`
--
ALTER TABLE `sessoes`
  ADD CONSTRAINT `fk_sessoes_utilizador` FOREIGN KEY (`id_utilizador`) REFERENCES `utilizadores` (`id_utilizador`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `transacoes_vendedor`
--
ALTER TABLE `transacoes_vendedor`
  ADD CONSTRAINT `fk_tv_encomenda` FOREIGN KEY (`id_encomenda`) REFERENCES `encomendas` (`id_encomenda`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_tv_vendedor` FOREIGN KEY (`id_vendedor`) REFERENCES `utilizadores` (`id_utilizador`);

--
-- Limitadores para a tabela `utilizadores`
--
ALTER TABLE `utilizadores`
  ADD CONSTRAINT `fk_utilizadores_role` FOREIGN KEY (`id_role`) REFERENCES `roles` (`id_role`);

--
-- Limitadores para a tabela `utilizador_badges`
--
ALTER TABLE `utilizador_badges`
  ADD CONSTRAINT `fk_ub_badge` FOREIGN KEY (`id_badge`) REFERENCES `badges` (`id_badge`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_ub_user` FOREIGN KEY (`id_utilizador`) REFERENCES `utilizadores` (`id_utilizador`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `utilizador_seguranca`
--
ALTER TABLE `utilizador_seguranca`
  ADD CONSTRAINT `fk_seguranca_utilizador` FOREIGN KEY (`id_utilizador`) REFERENCES `utilizadores` (`id_utilizador`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
