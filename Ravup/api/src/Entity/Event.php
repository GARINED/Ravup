<?php

namespace App\Entity;

use ApiPlatform\Core\Annotation\ApiResource;
use Doctrine\Common\Collections\ArrayCollection;
use Doctrine\Common\Collections\Collection;
use Doctrine\ORM\Mapping as ORM;
use ApiPlatform\Core\Annotation\ApiFilter;
use ApiPlatform\Core\Bridge\Doctrine\Orm\Filter\SearchFilter;

/**
 * @ApiResource(
 *     collectionOperations={
 *          "get",
 *          "post"
 *      },
 *     itemOperations={
 *          "get",
 *          "put"
 *     },
 *     normalizationContext={"groups"={"event:read"}},
 *     denormalizationContext={"groups"={"event:write"}}
 * )
 * @ORM\Entity(repositoryClass="App\Repository\EventRepository")
 * @ApiFilter(SearchFilter::class, properties={"status": "exact"})
 */
class Event
{
    /**
     * @ORM\Id()
     * @ORM\GeneratedValue(strategy="UUID")
     * @ORM\Column(type="guid")
     */
    private $id;

    /**
     * @ORM\Column(type="string", length=255)
     */
    private $name;

    /**
     * @ORM\Column(type="string", length=255, nullable=true)
     */
    private $shortDescription;

    /**
     * @ORM\Column(type="string", length=1000, nullable=true)
     */
    private $longDescription;

    /**
     * @ORM\Column(type="string", length=255, nullable=true)
     */
    private $type;

    /**
     * @ORM\Column(type="string", length=255, nullable=true)
     */
    private $location;

    /**
     * @ORM\ManyToOne(targetEntity="App\Entity\User", inversedBy="createdEvents", cascade={"persist"})
     * @ORM\JoinColumn(nullable=false)
     */
    private $creator;

    /**
     * @ORM\Column(type="string", length=255)
     */
    private $status;

    /**
     * @ORM\Column(type="integer", nullable=true)
     */
    private $ageMin;

    /**
     * @ORM\Column(type="integer", nullable=true)
     */
    private $price;

    /**
     * @ORM\Column(type="boolean")
     */
    private $autoAccept;

    /**
     * @ORM\Column(type="integer", nullable=true)
     */
    private $maxParticipate;

    /**
     * @ORM\Column(type="boolean")
     */
    private $authorizationDate;

    /**
     * @ORM\OneToMany(targetEntity="App\Entity\Participation", mappedBy="event")
     */
    private $userParticipations;

    /**
     * @ORM\OneToMany(targetEntity="App\Entity\Date", mappedBy="event")
     */
    private $dateList;

    /**
     * @ORM\OneToMany(targetEntity="App\Entity\Message", mappedBy="event")
     */
    private $messages;

    /**
     * @ORM\OneToMany(targetEntity="App\Entity\Sondage", mappedBy="event")
     */
    private $sondages;

    /**
     * @ORM\ManyToOne(targetEntity="App\Entity\Media")
     */
    private $coverPicture;

    /**
     * @ORM\ManyToMany(targetEntity="App\Entity\Media", inversedBy="events")
     */
    private $pictures;

    public function __construct()
    {
        $this->userParticipations = new ArrayCollection();
        $this->dateList = new ArrayCollection();
        $this->messages = new ArrayCollection();
        $this->sondages = new ArrayCollection();
        $this->pictures = new ArrayCollection();
    }

    public function getId()
    {
        return $this->id;
    }

    public function getName(): ?string
    {
        return $this->name;
    }

    public function setName(string $name): self
    {
        $this->name = $name;

        return $this;
    }

    public function getShortDescription(): ?string
    {
        return $this->shortDescription;
    }

    public function setShortDescription(?string $shortDescription): self
    {
        $this->shortDescription = $shortDescription;

        return $this;
    }

    public function getLongDescription(): ?string
    {
        return $this->longDescription;
    }

    public function setLongDescription(?string $longDescription): self
    {
        $this->longDescription = $longDescription;

        return $this;
    }

    public function getType(): ?string
    {
        return $this->type;
    }

    public function setType(?string $type): self
    {
        $this->type = $type;

        return $this;
    }

    public function getLocation(): ?string
    {
        return $this->location;
    }

    public function setLocation(?string $location): self
    {
        $this->location = $location;

        return $this;
    }

    public function getCreator(): ?User
    {
        return $this->creator;
    }

    public function setCreator(?User $creator): self
    {
        $this->creator = $creator;

        return $this;
    }

    public function getStatus(): ?string
    {
        return $this->status;
    }

    public function setStatus(string $status): self
    {
        $this->status = $status;

        return $this;
    }

    public function getAgeMin(): ?int
    {
        return $this->ageMin;
    }

    public function setAgeMin(?int $ageMin): self
    {
        $this->ageMin = $ageMin;

        return $this;
    }

    public function getPrice(): ?int
    {
        return $this->price;
    }

    public function setPrice(?int $price): self
    {
        $this->price = $price;

        return $this;
    }

    public function getAutoAccept(): ?bool
    {
        return $this->autoAccept;
    }

    public function setAutoAccept(bool $autoAccept): self
    {
        $this->autoAccept = $autoAccept;

        return $this;
    }

    public function getMaxParticipate(): ?int
    {
        return $this->maxParticipate;
    }

    public function setMaxParticipate(?int $maxParticipate): self
    {
        $this->maxParticipate = $maxParticipate;

        return $this;
    }

    public function getAuthorizationDate(): ?bool
    {
        return $this->authorizationDate;
    }

    public function setAuthorizationDate(bool $authorizationDate): self
    {
        $this->authorizationDate = $authorizationDate;

        return $this;
    }

    /**
     * @return Collection|Participation[]
     */
    public function getUserParticipations(): Collection
    {
        return $this->userParticipations;
    }

    public function addUserParticipation(Participation $userParticipation): self
    {
        if (!$this->userParticipations->contains($userParticipation)) {
            $this->userParticipations[] = $userParticipation;
            $userParticipation->setEvent($this);
        }

        return $this;
    }

    public function removeUserParticipation(Participation $userParticipation): self
    {
        if ($this->userParticipations->contains($userParticipation)) {
            $this->userParticipations->removeElement($userParticipation);
            // set the owning side to null (unless already changed)
            if ($userParticipation->getEvent() === $this) {
                $userParticipation->setEvent(null);
            }
        }

        return $this;
    }

    /**
     * @return Collection|Date[]
     */
    public function getDateList(): Collection
    {
        return $this->dateList;
    }

    public function addDateList(Date $dateList): self
    {
        if (!$this->dateList->contains($dateList)) {
            $this->dateList[] = $dateList;
            $dateList->setEvent($this);
        }

        return $this;
    }

    public function removeDateList(Date $dateList): self
    {
        if ($this->dateList->contains($dateList)) {
            $this->dateList->removeElement($dateList);
            // set the owning side to null (unless already changed)
            if ($dateList->getEvent() === $this) {
                $dateList->setEvent(null);
            }
        }

        return $this;
    }

    /**
     * @return Collection|Message[]
     */
    public function getMessages(): Collection
    {
        return $this->messages;
    }

    public function addMessage(Message $message): self
    {
        if (!$this->messages->contains($message)) {
            $this->messages[] = $message;
            $message->setEvent($this);
        }

        return $this;
    }

    public function removeMessage(Message $message): self
    {
        if ($this->messages->contains($message)) {
            $this->messages->removeElement($message);
            // set the owning side to null (unless already changed)
            if ($message->getEvent() === $this) {
                $message->setEvent(null);
            }
        }

        return $this;
    }

    /**
     * @return Collection|Sondage[]
     */
    public function getSondages(): Collection
    {
        return $this->sondages;
    }

    public function addSondage(Sondage $sondage): self
    {
        if (!$this->sondages->contains($sondage)) {
            $this->sondages[] = $sondage;
            $sondage->setEvent($this);
        }

        return $this;
    }

    public function removeSondage(Sondage $sondage): self
    {
        if ($this->sondages->contains($sondage)) {
            $this->sondages->removeElement($sondage);
            // set the owning side to null (unless already changed)
            if ($sondage->getEvent() === $this) {
                $sondage->setEvent(null);
            }
        }

        return $this;
    }

    public function getCoverPicture(): ?Media
    {
        return $this->coverPicture;
    }

    public function setCoverPicture(?Media $coverPicture): self
    {
        $this->coverPicture = $coverPicture;

        return $this;
    }

    /**
     * @return Collection|Media[]
     */
    public function getPictures(): Collection
    {
        return $this->pictures;
    }

    public function addPicture(Media $picture): self
    {
        if (!$this->pictures->contains($picture)) {
            $this->pictures[] = $picture;
        }

        return $this;
    }

    public function removePicture(Media $picture): self
    {
        if ($this->pictures->contains($picture)) {
            $this->pictures->removeElement($picture);
        }

        return $this;
    }
}
