<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

/**
 * Auto-generated Migration: Please modify to your needs!
 */
final class Version20190402085718 extends AbstractMigration
{
    public function getDescription() : string
    {
        return '';
    }

    public function up(Schema $schema) : void
    {
        // this up() migration is auto-generated, please modify it to your needs
        $this->abortIf($this->connection->getDatabasePlatform()->getName() !== 'postgresql', 'Migration can only be executed safely on \'postgresql\'.');

        $this->addSql('CREATE TABLE information (id UUID NOT NULL, info VARCHAR(255) NOT NULL, PRIMARY KEY(id))');
        $this->addSql('CREATE TABLE validation (id UUID NOT NULL, related_user_id UUID NOT NULL, information_id UUID NOT NULL, state INT NOT NULL, PRIMARY KEY(id))');
        $this->addSql('CREATE INDEX IDX_16AC5B6E98771930 ON validation (related_user_id)');
        $this->addSql('CREATE INDEX IDX_16AC5B6E2EF03101 ON validation (information_id)');
        $this->addSql('ALTER TABLE validation ADD CONSTRAINT FK_16AC5B6E98771930 FOREIGN KEY (related_user_id) REFERENCES users (id) NOT DEFERRABLE INITIALLY IMMEDIATE');
        $this->addSql('ALTER TABLE validation ADD CONSTRAINT FK_16AC5B6E2EF03101 FOREIGN KEY (information_id) REFERENCES information (id) NOT DEFERRABLE INITIALLY IMMEDIATE');
    }

    public function down(Schema $schema) : void
    {
        // this down() migration is auto-generated, please modify it to your needs
        $this->abortIf($this->connection->getDatabasePlatform()->getName() !== 'postgresql', 'Migration can only be executed safely on \'postgresql\'.');

        $this->addSql('ALTER TABLE validation DROP CONSTRAINT FK_16AC5B6E2EF03101');
        $this->addSql('DROP TABLE information');
        $this->addSql('DROP TABLE validation');
    }
}
