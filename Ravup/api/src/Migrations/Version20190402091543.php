<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

/**
 * Auto-generated Migration: Please modify to your needs!
 */
final class Version20190402091543 extends AbstractMigration
{
    public function getDescription() : string
    {
        return '';
    }

    public function up(Schema $schema) : void
    {
        // this up() migration is auto-generated, please modify it to your needs
        $this->abortIf($this->connection->getDatabasePlatform()->getName() !== 'postgresql', 'Migration can only be executed safely on \'postgresql\'.');

        $this->addSql('CREATE TABLE sondage (id UUID NOT NULL, event_id UUID NOT NULL, question VARCHAR(255) NOT NULL, PRIMARY KEY(id))');
        $this->addSql('CREATE INDEX IDX_7579C89F71F7E88B ON sondage (event_id)');
        $this->addSql('ALTER TABLE sondage ADD CONSTRAINT FK_7579C89F71F7E88B FOREIGN KEY (event_id) REFERENCES event (id) NOT DEFERRABLE INITIALLY IMMEDIATE');
        $this->addSql('ALTER TABLE information ADD sondage_id UUID NOT NULL');
        $this->addSql('ALTER TABLE information ADD CONSTRAINT FK_29791883BAF4AE56 FOREIGN KEY (sondage_id) REFERENCES sondage (id) NOT DEFERRABLE INITIALLY IMMEDIATE');
        $this->addSql('CREATE INDEX IDX_29791883BAF4AE56 ON information (sondage_id)');
    }

    public function down(Schema $schema) : void
    {
        // this down() migration is auto-generated, please modify it to your needs
        $this->abortIf($this->connection->getDatabasePlatform()->getName() !== 'postgresql', 'Migration can only be executed safely on \'postgresql\'.');

        $this->addSql('ALTER TABLE information DROP CONSTRAINT FK_29791883BAF4AE56');
        $this->addSql('DROP TABLE sondage');
        $this->addSql('DROP INDEX IDX_29791883BAF4AE56');
        $this->addSql('ALTER TABLE information DROP sondage_id');
    }
}
