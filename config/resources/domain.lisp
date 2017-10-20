(in-package :mu-cl-resources)

(setf *supply-cache-headers-p* t)
(setf *cache-model-properties-p* t)

(define-resource pillar ()
  :class (s-prefix "esco:ConceptScheme")
  :properties `((:preflabel :string-set ,(s-prefix "skos:prefLabel"))
                (:description :string ,(s-prefix "dcterms:description")))
  :resource-base (s-url "http://data.europa.eu/esco/concept-scheme/")
  :has-many `((concept :via ,(s-prefix "skos:topConceptOf")
                     :inverse t
                     :as "top-concepts")
              (structure :via ,(s-prefix "esco:structureFor")
                      :inverse t
                      :as "structures"))
  :on-path "taxonomies")

(define-resource concept-scheme ()
  :class (s-prefix "skos:ConceptScheme")
  :properties `((:preflabel :string-set ,(s-prefix "skos:prefLabel"))
                (:description :string ,(s-prefix "dcterms:description")))
  :resource-base (s-url "http://data.europa.eu/esco/concept-scheme/")
  :has-many `((concept :via ,(s-prefix "skos:topConceptOf")
                     :inverse t
                     :as "top-concepts")
             (concept :via ,(s-prefix "skos:inScheme")
                     :inverse t
                     :as "members"))
  :on-path "concept-schemes")

(define-resource structure ()
  :class (s-prefix "esco:Structure")
  :properties `((:name :string ,(s-prefix "skos:prefLabel"))
                (:description :string ,(s-prefix "dcterms:description"))
                (:coded-property :uri ,(s-prefix "esco:codedProperty"))
                (:default :string ,(s-prefix "esco:is-default-structure"))
                (:disabled :string ,(s-prefix "esco:is-disabled")))
  :has-one `((pillar :via ,(s-prefix "esco:structureFor")
                      :as "pillar")
            (concept-scheme :via ,(s-prefix "esco:codeList")
                      :as "code-list"))
  :resource-base (s-url "http://mu.semte.ch/vocabularies/hierarchy/")
  :on-path "structures")


(define-resource bookmark ()
  :class (s-prefix "mu:bookmark")
  :properties `((:bookmark-date :string,(s-prefix "mu:bookmarkDate")))
  :has-one `((concept :via ,(s-prefix "mu:bookmarkConcept")
                    :as "bookmark-concept"))
  :resource-base (s-url "http://mu.semte.ch/vocabularies/bookmarks/")
  :on-path "bookmarks")

(define-resource notification ()
  :class (s-prefix "mu:Notification")
  :properties `((:notification-type :string ,(s-prefix "mu:notificationType"))
                (:purpose :string ,(s-prefix "mu:notificationPurpose"))
                (:message :string ,(s-prefix "mu:notificationMessage"))
                (:expiration-date :string ,(s-prefix "mu:notificationExpirationDate"))
                (:list-button :string ,(s-prefix "mu:notificationListButton"))
                (:list :string-set ,(s-prefix "mu:notificationList")))
  :resource-base (s-url "http://mu.semte.ch/vocabularies/notifications/")
  :on-path "notifications")

(define-resource validation-result-collection ()
  :class (s-prefix "mu:validationResultCollection")
  :properties `((:timestamp :string ,(s-prefix "mu:timestamp"))
                (:status :string ,(s-prefix "mu:status"))
                (:rule-id :string ,(s-prefix "mu:ruleId"))
                (:parameters :string-set ,(s-prefix "mu:parameters"))
                (:types :string-set ,(s-prefix "mu:types")))
  :features '(include-count)
  :has-many `((validation-result :via ,(s-prefix "mu:hasResult")
                     :as "validation-results"))
  :resource-base (s-url "http://mu.semte.ch/vocabularies/validationResultCollection/")
  :on-path "validation-result-collections")

(define-resource validation-result ()
  :class (s-prefix "mu:validationResult")
  :properties `((:parameter-uuid :string ,(s-prefix "mu:parameteruuid"))
                (:parameter-language :string-set ,(s-prefix "mu:parameterlanguage"))
                (:parameter-preflabel :string-set ,(s-prefix "mu:parameterpreflabel"))
                (:parameter-literal-form :string-set ,(s-prefix "mu:parameterliteralForm"))
                (:parameter-duplicate-in :string-set ,(s-prefix "mu:parameterduplicateIn"))
                (:timestamp :string ,(s-prefix "mu:timestamp"))
                (:rule-id :string ,(s-prefix "mu:ruleId"))
                (:parameter-type :string-set ,(s-prefix "mu:parametertype")))
  :features '(include-count)
  :has-one `((validation-result-collection :via ,(s-prefix "mu:hasResult")
                     :inverse t
                     :as "validation-result-collection"))
  :resource-base (s-url "http://mu.semte.ch/vocabularies/validationResult/")
  :on-path "validation-results")

(define-resource account ()
  :class (s-prefix "foaf:OnlineAccount")
  :properties `((:status :string ,(s-prefix "account:status")))
  :resource-base (s-url "http://translation.escoportal.eu/accounts/")
  :has-one `((user :via ,(s-prefix "foaf:account")
                   :inverse t
                   :as "user"))
  :on-path "accounts"
)

(define-resource user ()
  :class (s-prefix "foaf:Person")
  :properties `((:name :string ,(s-prefix "foaf:name"))
                (:language :string ,(s-prefix "dcterms:language"))
                (:disable-shortcuts :string ,(s-prefix "mu:disableShortcuts"))
                (:show-isco-in-chosen-language :string ,(s-prefix "mu:showIscoInChosenLanguage"))
				        (:role :string ,(s-prefix "mu:role")))
  :has-many `((account :via ,(s-prefix "foaf:account")
                      :as "accounts")
              (group :via ,(s-prefix "foaf:member")
              :inverse t
              :as "groups")
              (bookmark :via ,(s-prefix "mu:hasBookmarks")
                      :as "bookmarks"))
  :resource-base (s-url "http://translation.escoportal.eu/users/")
  :on-path "users")

(define-resource group ()
  :class (s-prefix "trans:EcasGroup")
  :properties `((:name :string ,(s-prefix "foaf:name")))
  :has-many `((user :via ,(s-prefix "foaf:member")
              :as "members"))
  :resource-base (s-url "http://translation.escoportal.eu/groups/")
  :on-path "groups"
)

(define-resource concept-label ()
  :class (s-prefix "skosxl:Label")
  :properties `((:literal-form-values :language-string-set ,(s-prefix "skosxl:literalForm"))
                (:source :string ,(s-prefix "mu:source"))
                (:is-editable :string ,(s-prefix "etms:isEditable"))
                (:last-modified :string ,(s-prefix "esco:last-modified")))
  :resource-base (s-url "http://data.europa.eu/esco/label/")
  :features '(no-pagination-defaults)
  :has-many `((label-role :via ,(s-prefix "esco:hasLabelRole")
                    :as "roles")
			        (concept :via ,(s-prefix "skosxl:altLabel")
                    :inverse t
                    :as "alt-label-of")
              (concept :via ,(s-prefix "skosxl:hiddenLabel")
                    :inverse t
                    :as "hidden-label-of"))
	:has-one `((concept :via ,(s-prefix "skosxl:prefLabel")
					          :inverse t
                    :as "pref-label-of")
            (user :via ,(s-prefix "esco:last-modifier")
                    :as "last-modifier"))
  :on-path "concept-labels")

(define-resource label-role ()
  :class (s-prefix "esco:LabelRole")
  :properties `((:preflabel :string ,(s-prefix "skos:prefLabel")))
  :resource-base (s-url "http://data.europa.eu/esco/label-role/")
  :features '(no-pagination-defaults)
  :has-many `((concept-label :via ,(s-prefix "esco:hasLabelRole")
                :inverse t
                :as "role-of"))
  :on-path "label-roles")

(define-resource publication-status ()
  :class (s-prefix "etms:publicationStatus")
  :properties `((:label :string ,(s-prefix "etms:publicationLabel"))
                (:editable :string ,(s-prefix "etms:publicationEditable"))
                (:before-published :string ,(s-prefix "etms:publicationBeforePublished"))
                (:after-published :string ,(s-prefix "etms:publicationAfterPublished"))
                (:editable :string ,(s-prefix "etms:publicationEditable"))
                (:selectable :string ,(s-prefix "etms:publicationSelectable")))
  :resource-base (s-url "http://mu.semte.ch/vocabularies/publicationStatus/")
  :on-path "publication-statuses")

(define-resource concept ()
  :class (s-prefix "skos:Concept")
  :properties `((:codes :string-set ,(s-prefix "dcterms:identifier"))
                (:types :uri-set ,(s-prefix "rdf:type"))
                (:is-editable :string ,(s-prefix "etms:isEditable"))
                (:description :language-string-set ,(s-prefix "dcterms:description"))
                (:scope-note :language-string-set ,(s-prefix "skos:scopeNote"))
                (:esco-note :string ,(s-prefix "esco:note"))
                (:is-under-creation :string ,(s-prefix "mu:isUnderCreation"))
                (:definition :language-string-set ,(s-prefix "skos:definition"))
                (:skill-type :uri-set ,(s-prefix "esco:skillType"))
                (:issued :string ,(s-prefix "dcterms:issued"))
                (:last-modified :string ,(s-prefix "esco:last-modified")))
  :features '(no-pagination-defaults)
  :resource-base (s-url "http://data.europa.eu/esco/concept/")
  :has-one `((user :via ,(s-prefix "esco:last-modifier")
                      :as "last-modifier")
            (concept :via ,(s-prefix "esco:skillType")
                      :as "skill-type-concept")
            (concept :via ,(s-prefix "esco:skillReuseLevel")
                      :as "skill-reuse-level")
            (concept :via ,(s-prefix "esco:regulatedProfessionNote")
                      :as "under-regulation")
            (publication-status :via ,(s-prefix "etms:hasPublicationStatus")
                      :as "has-publication-status"))
  :has-many `((concept-label :via ,(s-prefix "skosxl:altLabel")
                     :as "alt-labels")
			  (concept-label :via ,(s-prefix "skosxl:hiddenLabel")
                     :as "hidden-labels")
			  (concept-label :via ,(s-prefix "skosxl:prefLabel")
                     :as "pref-labels")
			  (concept :via ,(s-prefix "skos:broader")
                     :inverse t
                     :as "narrower")
			  (concept :via ,(s-prefix "skos:broader")
                     :as "broader")
        (concept :via ,(s-prefix "esco:hasNACECode")
                     :as "nace")
			  (concept :via ,(s-prefix "dcterms:replaces")
                     :inverse t
                     :as "replaces")
        (concept :via ,(s-prefix "dcterms:isReplacedBy")
                     :as "replacements")
        (concept-relation :via ,(s-prefix "esco:isRelationshipFor")
                     :inverse t
                     :as "relations")
        (concept-relation :via ,(s-prefix "esco:refersConcept")
                     :inverse t
                     :as "inverse-relations")
			  (concept-scheme :via ,(s-prefix "skos:inScheme")
                     :as "taxonomy")
			  (concept-scheme :via ,(s-prefix "skos:topConceptOf")
                     :as "top-concept-of")
			  (bookmark :via ,(s-prefix "mu:bookmarkConcept")
                     :inverse t
                     :as "bookmarked-by"))
  :on-path "concepts")

(define-resource concept-relation ()
  :class (s-prefix "esco:Relationship")
  :properties `((:type :uri-set ,(s-prefix "esco:hasRelationshipType"))
               (:is-editable :string ,(s-prefix "etms:isEditable"))
               (:last-modified :string ,(s-prefix "esco:last-modified")))
  :features '(no-pagination-defaults)
  :resource-base (s-url "http://data.europa.eu/esco/relation/")
  :has-one `((user :via ,(s-prefix "esco:last-modifier")
                      :as "last-modifier")
             (concept :via ,(s-prefix "esco:isRelationshipFor")
                    :as "from")
             (concept :via ,(s-prefix "esco:refersConcept")
                    :as "to"))
  :on-path "concept-relations")

(define-resource comment ()
  :class (s-prefix "esco:Comment")
  :properties `((:status :string ,(s-prefix "esco:status"))
                (:language :string ,(s-prefix "esco:language"))
                (:content :language-string-set ,(s-prefix "esco:content"))
                (:creation-date :string ,(s-prefix "esco:creation-date"))
                (:modification-date :string ,(s-prefix "esco:modification-date")))
  :resource-base (s-url "http://data.europa.eu/esco/comment/")
  :has-one `((concept :via ,(s-prefix "esco:isCommentFor")
            :as "about")
            (user :via ,(s-prefix "esco:isCommentBy")
            :as "author")
            (comment-notification :via ,(s-prefix "esco:notificationFor")
            :inverse t
            :as "notification"))
  :on-path "comments")

(define-resource comment-notification ()
  :class (s-prefix "esco:CommentNotification")
  :properties `((:status :string ,(s-prefix "esco:status"))
                (:created-when :string ,(s-prefix "esco:content"))
                (:solved :string ,(s-prefix "esco:solved"))
                (:solved-when :string ,(s-prefix "esco:solved-date")))
  :resource-base (s-url "http://data.europa.eu/esco/comment-notification/")
  :has-one `((user :via ,(s-prefix "esco:createdBy")
            :as "created-by")
            (user :via ,(s-prefix "esco:solvedBy")
            :as "solved-by")
            (comment :via ,(s-prefix "esco:notificationFor")
            :as "comment"))
  :has-many `((notification-assignment :via ,(s-prefix "esco:assignmentFor")
              :inverse t
              :as "assignments"))
  :on-path "comment-notifications")

(define-resource notification-assignment()
  :class (s-prefix "esco:NotificationAssignment")
  :properties `((:status :string ,(s-prefix "esco:status")))
  :resource-base (s-url "http://data.europa.eu/esco/notification-assignment")
  :has-one `((user :via ,(s-prefix "esco:assignedTo")
            :as "assigned-to")
            (comment-notification :via ,(s-prefix "esco:assignmentFor")
            :as "notification"))
  :on-path "notification-assignments")


(define-resource clear-cache-request ()
  :class (s-prefix "ext:ClearCacheRequest")
  :resource-base (s-url "http://mu.semte.ch/ext/resources/clear-cache-requests/")
  :on-path "clear-cache-requests")

(defun clear-cached-resources ()
  "Clears all the cached resources from the store."
  (setf *cached-resources* (make-hash-table :test 'equal #-abcl :synchronized #-abcl t)))

(before (:create clear-cache-request) (&rest args)
  (declare (ignore args))
  (clear-cached-resources))
