<?php
/**
 * Created by PhpStorm.
 * User: GARINE_D
 * Date: 2/7/19
 * Time: 8:24 PM
 */

namespace App\Entity;

use ApiPlatform\Core\Annotation\ApiResource;
use Doctrine\Common\Collections\ArrayCollection;
use Doctrine\Common\Collections\Collection;
use Doctrine\ORM\Mapping as ORM;
use FOS\UserBundle\Model\User as BaseUser;
use FOS\UserBundle\Model\UserInterface;
use Symfony\Component\Serializer\Annotation\Groups;
use ApiPlatform\Core\Annotation\ApiFilter;
use ApiPlatform\Core\Bridge\Doctrine\Orm\Filter\SearchFilter;

/**
 * @ORM\Entity
 * @ORM\Table(name="users")
 * @ApiResource(
 *     collectionOperations={
 *          "get",
 *          "post"
 *      },
 *     itemOperations={"get", "put"},
 *     normalizationContext={"groups"={"user:read"}},
 *     denormalizationContext={"groups"={"user:write"}}
 * )
 * @ApiFilter(SearchFilter::class, properties={"username": "partial"})
 */
class User extends BaseUser
{
    /**
     * @ORM\Id()
     * @ORM\GeneratedValue(strategy="UUID")
     * @ORM\Column(type="guid")
     */
    protected $id;

    protected $email;

    /**
     * @ORM\Column(type="string", length=255, nullable=true)
     */
    protected $fullname;

    /**
     * @ORM\Column(type="integer", nullable=true)
     */
    protected $age;

    /**
     * @ORM\Column(type="integer", nullable=true)
     */
    protected $score;

    /**
     * @ORM\Column(type="string", length = 255, nullable=true)
     */
    protected $sexe;

    /**
     * @ORM\Column(type="string", length = 255, nullable=true)
     */
    protected $city;

    /**
     * @ORM\Column(type="string", length = 255, nullable=true)
     */
    protected $country;

    /**
     * @ORM\Column(type="string", nullable=true)
     * @Groups({"user"})
     */
    protected $biography;

    /**
     * @var array
     */
    protected $roles;

    /**
     * @ORM\ManyToOne(targetEntity="App\Entity\Structure")
     * @ORM\JoinColumn(nullable=true)
     */
    private $structure;

    /**
     * @ORM\OneToMany(targetEntity="App\Entity\Media", mappedBy="owner")
     */
    private $media;

    /**
     * @ORM\OneToMany(targetEntity="App\Entity\Event", mappedBy="creator", orphanRemoval=true)
     */
    private $createdEvents;

    /**
     * @ORM\OneToMany(targetEntity="App\Entity\Message", mappedBy="author", orphanRemoval=true)
     */
    private $messages;

    /**
     * @ORM\OneToMany(targetEntity="App\Entity\Participation", mappedBy="relatedUser")
     */
    private $eventParticipations;

    /**
     * @ORM\OneToMany(targetEntity="App\Entity\Validation", mappedBy="relatedUser", orphanRemoval=true)
     */
    private $validations;

    /**
     * @ORM\OneToOne(targetEntity="App\Entity\Media")
     */
    private $profilPicture;

    /**
     * @ORM\OneToMany(targetEntity="App\Entity\Notification", mappedBy="recipient", orphanRemoval=true)
     */
    private $notifications;

    public function __construct()
    {
        parent::__construct();
        $this->media = new ArrayCollection();
        $this->createdEvents = new ArrayCollection();
        $this->groupJoin = new ArrayCollection();
        $this->createdGroup = new ArrayCollection();
        $this->messages = new ArrayCollection();
        $this->eventParticipations = new ArrayCollection();
        $this->validations = new ArrayCollection();
        $this->notifications = new ArrayCollection();
    }

    public function setFullname(?string $fullname): void
    {
        $this->fullname = $fullname;
    }

    public function getFullname(): ?string
    {
        return $this->fullname;
    }

    public function isUser(?UserInterface $user = null): bool
    {
        return $user instanceof self && $user->id === $this->id;
    }

    public function getStructure(): ?Structure
    {
        return $this->structure;
    }

    public function setStructure(Structure $structure): self
    {
        $this->structure = $structure;

        return $this;
    }

    public function getProfilePicture(): ?Media
    {
        return $this->profilePicture;
    }

    public function setProfilePicture(Media $profilePicture)
    {
        $this->profilePicture = $profilePicture;

        return $this;
    }

    /**
     * @return Collection|Media[]
     */
    public function getMedia(): Collection
    {
        return $this->media;
    }

    public function addMedium(Media $medium): self
    {
        if (!$this->media->contains($medium)) {
            $this->media[] = $medium;
            $medium->setOwner($this);
        }

        return $this;
    }

    public function removeMedium(Media $medium): self
    {
        if ($this->media->contains($medium)) {
            $this->media->removeElement($medium);
            // set the owning side to null (unless already changed)
            if ($medium->getOwner() === $this) {
                $medium->setOwner(null);
            }
        }

        return $this;
    }

    /**
     * @return Collection|Event[]
     */
    public function getCreatedEvents(): Collection
    {
        return $this->createdEvents;
    }

    public function addCreatedEvent(Event $createdEvent): self
    {
        if (!$this->createdEvents->contains($createdEvent)) {
            $this->createdEvents[] = $createdEvent;
            $createdEvent->setCreator($this);
        }

        return $this;
    }

    public function removeCreatedEvent(Event $createdEvent): self
    {
        if ($this->createdEvents->contains($createdEvent)) {
            $this->createdEvents->removeElement($createdEvent);
            // set the owning side to null (unless already changed)
            if ($createdEvent->getCreator() === $this) {
                $createdEvent->setCreator(null);
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
            $message->setAuthor($this);
        }

        return $this;
    }

    public function removeMessage(Message $message): self
    {
        if ($this->messages->contains($message)) {
            $this->messages->removeElement($message);
            // set the owning side to null (unless already changed)
            if ($message->getAuthor() === $this) {
                $message->setAuthor(null);
            }
        }

        return $this;
    }

    /**
     * @return Collection|Participation[]
     */
    public function getEventParticipations(): Collection
    {
        return $this->eventParticipations;
    }

    public function addEventParticipation(Participation $eventParticipation): self
    {
        if (!$this->eventParticipations->contains($eventParticipation)) {
            $this->eventParticipations[] = $eventParticipation;
            $eventParticipation->setRelatedUser($this);
        }

        return $this;
    }

    public function removeEventParticipation(Participation $eventParticipation): self
    {
        if ($this->eventParticipations->contains($eventParticipation)) {
            $this->eventParticipations->removeElement($eventParticipation);
            // set the owning side to null (unless already changed)
            if ($eventParticipation->getRelatedUser() === $this) {
                $eventParticipation->setRelatedUser(null);
            }
        }

        return $this;
    }

    /**
     * @return Collection|Validation[]
     */
    public function getValidations(): Collection
    {
        return $this->validations;
    }

    public function addValidation(Validation $validation): self
    {
        if (!$this->validations->contains($validation)) {
            $this->validations[] = $validation;
            $validation->setRelatedUser($this);
        }

        return $this;
    }

    public function removeValidation(Validation $validation): self
    {
        if ($this->validations->contains($validation)) {
            $this->validations->removeElement($validation);
            // set the owning side to null (unless already changed)
            if ($validation->getRelatedUser() === $this) {
                $validation->setRelatedUser(null);
            }
        }

        return $this;
    }

    /**
     * @return mixed
     */
    public function getScore()
    {
        return $this->score;
    }

    /**
     * @param mixed $score
     */
    public function setScore($score): void
    {
        $this->score = $score;
    }

    /**
     * @return mixed
     */
    public function getCity()
    {
        return $this->city;
    }

    /**
     * @param mixed $city
     */
    public function setCity($city): void
    {
        $this->city = $city;
    }

    /**
     * @return mixed
     */
    public function getCountry()
    {
        return $this->country;
    }

    /**
     * @param mixed $country
     */
    public function setCountry($country): void
    {
        $this->country = $country;
    }

    /**
     * @return mixed
     */
    public function getSexe()
    {
        return $this->sexe;
    }

    /**
     * @param mixed $sexe
     */
    public function setSexe($sexe): void
    {
        $this->sexe = $sexe;
    }

    /**
     * @return mixed
     */
    public function getBiography()
    {
        return $this->biography;
    }

    /**
     * @param mixed $biography
     */
    public function setBiography($biography): void
    {
        $this->biography = $biography;
    }

    /**
     * @return mixed
     */
    public function getAge()
    {
        return $this->age;
    }

    /**
     * @param mixed $age
     */
    public function setAge($age): void
    {
        $this->age = $age;
    }

    public function getProfilPicture(): ?Media
    {
        return $this->profilPicture;
    }

    public function setProfilPicture(Media $profilPicture): self
    {
        $this->profilPicture = $profilPicture;

        return $this;
    }

    /**
     * @return Collection|Notification[]
     */
    public function getNotifications(): Collection
    {
        return $this->notifications;
    }

    public function addNotification(Notification $notification): self
    {
        if (!$this->notifications->contains($notification)) {
            $this->notifications[] = $notification;
            $notification->setRecipient($this);
        }

        return $this;
    }

    public function removeNotification(Notification $notification): self
    {
        if ($this->notifications->contains($notification)) {
            $this->notifications->removeElement($notification);
            // set the owning side to null (unless already changed)
            if ($notification->getRecipient() === $this) {
                $notification->setRecipient(null);
            }
        }

        return $this;
    }
}
