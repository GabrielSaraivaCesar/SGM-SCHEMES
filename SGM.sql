-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema SGMDB
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `SGMDB` ;

-- -----------------------------------------------------
-- Schema SGMDB
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `SGMDB` DEFAULT CHARACTER SET utf8 ;
USE `SGMDB` ;

-- -----------------------------------------------------
-- Table `SGMDB`.`Loja`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `SGMDB`.`Loja` ;

CREATE TABLE IF NOT EXISTS `SGMDB`.`Loja` (
  `PK_idLoja` INT NOT NULL AUTO_INCREMENT,
  `Nome` VARCHAR(45) NULL,
  PRIMARY KEY (`PK_idLoja`),
  UNIQUE INDEX `idLoja_UNIQUE` (`PK_idLoja` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `SGMDB`.`Usuario_Tipo`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `SGMDB`.`Usuario_Tipo` ;

CREATE TABLE IF NOT EXISTS `SGMDB`.`Usuario_Tipo` (
  `PK_idUsuario_Tipo` INT NOT NULL AUTO_INCREMENT,
  `Descricao` VARCHAR(45) NULL,
  PRIMARY KEY (`PK_idUsuario_Tipo`),
  UNIQUE INDEX `idUsuario_Tipo_UNIQUE` (`PK_idUsuario_Tipo` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `SGMDB`.`Usuario`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `SGMDB`.`Usuario` ;

CREATE TABLE IF NOT EXISTS `SGMDB`.`Usuario` (
  `PK_idUsuario` INT NOT NULL AUTO_INCREMENT,
  `Nome` VARCHAR(45) NULL,
  `FK_Tipo_Usuario` INT NOT NULL,
  PRIMARY KEY (`PK_idUsuario`, `FK_Tipo_Usuario`),
  UNIQUE INDEX `idUsuario_UNIQUE` (`PK_idUsuario` ASC) VISIBLE,
  INDEX `fk_Usuario_Usuario_Tipo_idx` (`FK_Tipo_Usuario` ASC) VISIBLE,
  CONSTRAINT `fk_Usuario_Usuario_Tipo`
    FOREIGN KEY (`FK_Tipo_Usuario`)
    REFERENCES `SGMDB`.`Usuario_Tipo` (`PK_idUsuario_Tipo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `SGMDB`.`Loja_has_Usuario`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `SGMDB`.`Loja_has_Usuario` ;

CREATE TABLE IF NOT EXISTS `SGMDB`.`Loja_has_Usuario` (
  `FK_idLoja` INT NOT NULL,
  `FK_idUsuario` INT NOT NULL,
  PRIMARY KEY (`FK_idLoja`, `FK_idUsuario`),
  INDEX `fk_Loja_has_Usuario_Usuario1_idx` (`FK_idUsuario` ASC) VISIBLE,
  INDEX `fk_Loja_has_Usuario_Loja1_idx` (`FK_idLoja` ASC) VISIBLE,
  CONSTRAINT `fk_Loja_has_Usuario_Loja1`
    FOREIGN KEY (`FK_idLoja`)
    REFERENCES `SGMDB`.`Loja` (`PK_idLoja`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Loja_has_Usuario_Usuario1`
    FOREIGN KEY (`FK_idUsuario`)
    REFERENCES `SGMDB`.`Usuario` (`PK_idUsuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `SGMDB`.`Lote`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `SGMDB`.`Lote` ;

CREATE TABLE IF NOT EXISTS `SGMDB`.`Lote` (
  `PK_idLote` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Date` DATE NULL,
  `FK_idLoja` INT NOT NULL,
  PRIMARY KEY (`PK_idLote`, `FK_idLoja`),
  INDEX `fk_Lote_Loja1_idx` (`FK_idLoja` ASC) VISIBLE,
  CONSTRAINT `fk_Lote_Loja1`
    FOREIGN KEY (`FK_idLoja`)
    REFERENCES `SGMDB`.`Loja` (`PK_idLoja`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `SGMDB`.`Medicamento`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `SGMDB`.`Medicamento` ;

CREATE TABLE IF NOT EXISTS `SGMDB`.`Medicamento` (
  `PK_SKU` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Nome` VARCHAR(45) NULL,
  `Descricao` VARCHAR(255) NULL,
  `Preco` DOUBLE NULL,
  PRIMARY KEY (`PK_SKU`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `SGMDB`.`Item_Estoque`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `SGMDB`.`Item_Estoque` ;

CREATE TABLE IF NOT EXISTS `SGMDB`.`Item_Estoque` (
  `PK_idItemEstoque` INT NOT NULL AUTO_INCREMENT,
  `Quantidade` INT NULL,
  `DataVencimento` DATE NULL,
  `FK_produtoSKU` INT UNSIGNED NOT NULL,
  `FK_idLote` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`PK_idItemEstoque`, `FK_produtoSKU`, `FK_idLote`),
  INDEX `fk_Lote_has_Medicamento_Medicamento1_idx` (`FK_produtoSKU` ASC) VISIBLE,
  INDEX `fk_Lote_has_Medicamento_Lote1_idx` (`FK_idLote` ASC) VISIBLE,
  UNIQUE INDEX `PK_idItemEstoque_UNIQUE` (`PK_idItemEstoque` ASC) VISIBLE,
  CONSTRAINT `fk_Lote_has_Medicamento_Lote1`
    FOREIGN KEY (`FK_idLote`)
    REFERENCES `SGMDB`.`Lote` (`PK_idLote`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Lote_has_Medicamento_Medicamento1`
    FOREIGN KEY (`FK_produtoSKU`)
    REFERENCES `SGMDB`.`Medicamento` (`PK_SKU`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `SGMDB`.`Registro_Desperdicio`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `SGMDB`.`Registro_Desperdicio` ;

CREATE TABLE IF NOT EXISTS `SGMDB`.`Registro_Desperdicio` (
  `PK_idRegistro` INT NOT NULL AUTO_INCREMENT,
  `Quantidade` INT NULL,
  `Date` DATE NULL,
  `FK_idItem_Estoque` INT NOT NULL,
  PRIMARY KEY (`PK_idRegistro`),
  UNIQUE INDEX `PK_idRegistro_UNIQUE` (`PK_idRegistro` ASC) VISIBLE,
  INDEX `fk_Registro_Desperdicio_Item_Estoque1_idx` (`FK_idItem_Estoque` ASC) VISIBLE,
  CONSTRAINT `fk_Registro_Desperdicio_Item_Estoque1`
    FOREIGN KEY (`FK_idItem_Estoque`)
    REFERENCES `SGMDB`.`Item_Estoque` (`PK_idItemEstoque`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `SGMDB`.`Registro_Venda`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `SGMDB`.`Registro_Venda` ;

CREATE TABLE IF NOT EXISTS `SGMDB`.`Registro_Venda` (
  `PK_idRegistro` INT NOT NULL AUTO_INCREMENT,
  `Quantidade` INT NULL,
  `Date` DATE NULL,
  `FK_idItem_Estoque` INT NOT NULL,
  PRIMARY KEY (`PK_idRegistro`),
  UNIQUE INDEX `PK_idRegistro_UNIQUE` (`PK_idRegistro` ASC) VISIBLE,
  INDEX `fk_Registro_Venda_Item_Estoque1_idx` (`FK_idItem_Estoque` ASC) VISIBLE,
  CONSTRAINT `fk_Registro_Venda_Item_Estoque1`
    FOREIGN KEY (`FK_idItem_Estoque`)
    REFERENCES `SGMDB`.`Item_Estoque` (`PK_idItemEstoque`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
SET SQL_SAFE_UPDATES = 0;


DELETE FROM SGMDB.USUARIO_TIPO;
INSERT INTO SGMDB.USUARIO_TIPO VALUES(null, "GERENTE");
INSERT INTO SGMDB.USUARIO_TIPO VALUES(null, "VENDEDOR");
SELECT * FROM SGMDB.USUARIO_TIPO;

DELETE FROM SGMDB.USUARIO;
INSERT INTO SGMDB.USUARIO VALUES(null, "Usuario gerente", 1);
INSERT INTO SGMDB.USUARIO VALUES(null, "Usuario vendedor", 2);
SELECT u.*, ut.descricao as 'Tipo' FROM SGMDB.USUARIO u JOIN SGMDB.USUARIO_TIPO ut ON ut.PK_idUsuario_Tipo = u.FK_Tipo_Usuario;

DELETE FROM SGMDB.LOJA;
INSERT INTO SGMDB.LOJA VALUES(null, "Matriz");
SELECT * FROM SGMDB.LOJA;

DELETE FROM SGMDB.LOJA_HAS_USUARIO;
INSERT INTO SGMDB.LOJA_HAS_USUARIO VALUES (1, 1);
INSERT INTO SGMDB.LOJA_HAS_USUARIO VALUES (1, 2);
SELECT * FROM SGMDB.LOJA_HAS_USUARIO;
SELECT u.*, ut.descricao as 'Tipo', l.Nome as 'Loja' FROM SGMDB.USUARIO u 
	JOIN sgmdb.usuario_tipo ut ON ut.PK_idUsuario_Tipo = u.fk_tipo_usuario
	JOIN sgmdb.loja_has_usuario lu ON lu.FK_idUsuario = u.PK_idUsuario
    JOIN sgmdb.loja l ON l.PK_idLoja = lu.FK_idLoja;

DELETE FROM sgmdb.lote;
INSERT INTO sgmdb.lote VALUES (null, '2021-10-20', 1);
INSERT INTO sgmdb.lote VALUES (null, '2021-10-21', 1);
SELECT * FROM sgmdb.lote;

DELETE FROM sgmdb.medicamento;
INSERT INTO sgmdb.medicamento VALUES (null, "Ritalina", "Desc", 43.89);
INSERT INTO sgmdb.medicamento VALUES (null, "Rivotril", "Desc", 20.89);
SELECT * FROM sgmdb.medicamento;

DELETE FROM sgmdb.item_estoque;
INSERT INTO sgmdb.item_estoque VALUES (null, 10, "2021-12-10", 1, 1);
INSERT INTO sgmdb.item_estoque VALUES (null, 10, "2021-12-20", 1, 2);
INSERT INTO sgmdb.item_estoque VALUES (null, 5, "2021-12-20", 2, 2);
SELECT * FROM sgmdb.item_estoque;

DELETE FROM sgmdb.registro_desperdicio;
INSERT INTO sgmdb.registro_desperdicio VALUES (null, 2, "2021-11-10", 1);
INSERT INTO sgmdb.registro_desperdicio VALUES (null, 1, "2021-11-10", 1);
INSERT INTO sgmdb.registro_desperdicio VALUES (null, 4, "2021-11-10", 2);
INSERT INTO sgmdb.registro_desperdicio VALUES (null, 2, "2021-11-10", 3);
SELECT * FROM sgmdb.registro_desperdicio;

DELETE FROM sgmdb.registro_venda;
INSERT INTO sgmdb.registro_venda VALUES (null, 2, "2021-11-10", 1);
INSERT INTO sgmdb.registro_venda VALUES (null, 1, "2021-11-10", 1);
INSERT INTO sgmdb.registro_venda VALUES (null, 1, "2021-11-11", 2);
SELECT * FROM sgmdb.registro_venda;

# Relatorios
# Pegar medicamentos com quantidade
DROP VIEW IF EXISTS quantidade_vendas_por_lote;
CREATE VIEW quantidade_vendas_por_lote AS SELECT SUM(VEN.Quantidade) AS 'Vendas', LOT.PK_idLote AS 'Lote', MED.*
	FROM  sgmdb.medicamento MED
    JOIN sgmdb.item_estoque EST ON EST.FK_produtoSKU = MED.PK_SKU
    JOIN sgmdb.lote LOT ON LOT.PK_idLote = EST.FK_idLote
    JOIN sgmdb.registro_venda VEN ON EST.PK_idItemEstoque = VEN.FK_idItem_Estoque
    GROUP BY EST.PK_idItemEstoque;

DROP VIEW IF EXISTS quantidade_vendas;
CREATE VIEW quantidade_vendas AS SELECT MED.*, (SELECT IFNULL(SUM(QUANT.Vendas), 0)) AS "Vendas" 
	FROM quantidade_vendas_por_lote QUANT
	RIGHT JOIN sgmdb.medicamento MED ON MED.PK_SKU = QUANT.PK_SKU
    group by QUANT.PK_SKU;

DROP VIEW IF EXISTS quantidade_descartes_por_lote;
CREATE VIEW quantidade_descartes_por_lote AS SELECT SUM(DES.Quantidade) AS 'Descartes', LOT.PK_idLote AS 'Lote', MED.*
	FROM  sgmdb.medicamento MED
    JOIN sgmdb.item_estoque EST ON EST.FK_produtoSKU = MED.PK_SKU
    JOIN sgmdb.lote LOT ON LOT.PK_idLote = EST.FK_idLote
    JOIN sgmdb.registro_desperdicio DES ON EST.PK_idItemEstoque = DES.FK_idItem_Estoque
    GROUP BY EST.PK_idItemEstoque;

DROP VIEW IF EXISTS quantidade_descartes;
CREATE VIEW quantidade_descartes AS SELECT MED.*, (SELECT IFNULL(SUM(QUANT.Descartes), 0)) AS "Descartes" 
	FROM quantidade_descartes_por_lote QUANT
	RIGHT JOIN sgmdb.medicamento MED ON MED.PK_SKU = QUANT.PK_SKU
    group by QUANT.PK_SKU;

DROP VIEW IF EXISTS quantidade_total;
CREATE VIEW quantidade_total AS SELECT VEN.*, DES.Descartes as 'Descartes', SUM(IE.QUANTIDADE) - VEN.Vendas - DES.Descartes as 'Total' 
	FROM quantidade_vendas VEN
	JOIN quantidade_descartes DES ON DES.PK_SKU = VEN.PK_SKU
    JOIN sgmdb.item_estoque IE ON IE.FK_produtoSKU = DES.PK_SKU 
    GROUP BY VEN.PK_SKU;

SELECT * FROM quantidade_vendas_por_lote;
SELECT * FROM quantidade_descartes_por_lote;
SELECT * FROM quantidade_vendas;
SELECT * FROM quantidade_descartes;
SELECT * FROM quantidade_total;

# SET SQL_SAFE_UPDATES = 1;

