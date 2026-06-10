
<!-- ==================================================================
This liquid script creates a requirements reference list using input data from input/data/conformance-cdex.csv
which is updated when new narrative requirements are added to the guide.  Note that this table is used to create the Requirements Resources as well.
with the following columns:

- Is_New: Flag for new or updated content for the current version. Default is "FALSE"  or empty and set to "TRUE" for new or updated content for the current version. It is used for QA review and published ballot versions of the guide. It is set to empty before publishing new versions of the guide.
- row: row number
- key: A requirement key that identifies the requirement and links it to the statement in the guide. The format is "CONF-NNN" where NNN is a sequentially increasing zero padded integer.
- location: the source file and line number
- reference: The page or section topic that pertains to the requirement,
- category: CDex Category - based on the IG Menu layout and grouping.
- isConditional: Whether the conformance statement is conditional on some prerequisite.
- actor: The roles to which this requirement applies. The actors are: Data Source|Data Consumer|Signer|Verifier|?Payer
- conformance: Conformance Verb as defined in RFC 2119 that are used in the requirement + DEPRECATED for Conformance statements that have been removed.
- conformance_score: Conformance Verb score to enable sorting
- requirement: The actual requirements statement. The format is Markdown and is either a sentence, a list item , or even a paragraph to express a single requirement.
- comment: notes and comments about the conformance statement
-
The link target page is derived from the category column:

- Direct Query        -> direct-query.html
- Attachments         -> attachments-conformance.html
- Security and Privacy -> security.html
- Signatures          -> signatures.html
- Task Based Approach  -> task-based-conformance.html
- (any other category) -> foo.html
-
================================================================== -->


{% assign rows = site.data.conformance-cdex
  | where_exp: "item", "item.key.size > 0"
  | where_exp: "item", "item.conformance != 'DEPRECATED'" -%}
{% for item in rows -%}
{% case item.category -%}
{% when 'Direct Query' %}{% assign target = 'direct-query.html' %}
{%- when 'Attachments' %}{% assign target = 'attachments-conformance.html' %}
{%- when 'Security and Privacy' %}{% assign target = 'security.html' %}
{%- when 'Signatures' %}{% assign target = 'signatures.html' %}
{%- when 'Task Based Approach' %}{% assign target = 'task-based-conformance.html' %}
{%- else %}{% assign target = 'foo.html' %}
{%- endcase -%}
[{{item.key}}]: {{ target }}#{{item.key}} "{{item.key}}"
{% endfor %}

<!-- =============================== end liquid =================================== -->