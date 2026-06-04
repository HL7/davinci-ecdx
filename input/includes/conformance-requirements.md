<!-- ==================================================================
_includes/conformance-requirements.md

Renders the narrative conformance requirements for a SINGLE category, with
one table per actor. Intended to be dropped into the "Conformance" section of
each category page (e.g. signatures.md, direct-query.md) rather than collected
on one global page.

USAGE
  {% raw %}{% include conformance-requirements.md category="Signatures" %}{% endraw %}

  Optional parameters:
  - category   (required) Category to filter on. Must match the `category`
               column exactly, e.g. "Signatures", "Direct Query".
  - data       (default "conformance-cdex") Key of the data file under
               site.data. NOTE the hyphen: site.data must be reached with
               bracket notation -- site.data["conformance-cdex"] -- because
               dot notation (site.data.conformance-cdex) is parsed as a
               subtraction by Liquid.
  - actors     (optional) Comma-separated list to force the actor table order,
               e.g. actors="Data Source,Data Consumer". When omitted, the
               actors are derived from the rows in this category and sorted
               alphabetically.
  - heading    (default "####") Markdown heading level used for each
               "<actor> Requirements" subheading. Set to "#####" when the page
               already uses "####" for the Conformance section.
  - legend     (default false) Set legend=true to print the column legend
               above the tables.

DATA SOURCE: input/data/conformance-cdex.csv
Source columns (see also the Conventions section of the extraction script):

  - Is_New            (added) "TRUE" for new/updated content in the current
                      version; drives the bg-success row highlight. Cleared
                      before each publication.
  - row               (added) Sequential source-row number. QA bookkeeping
                      only; not rendered.
  - key               (added) Requirement key, format "CONF-NNN" (zero-padded
                      3 digits, stable across runs). Used for the row id and
                      to link the statement back to the guide.
  - location          (added) Source location "file.md:line" of the statement
                      (or of the include reference for statements inside a
                      Jekyll include). Provenance only; not rendered.
  - reference         (added) Relative output page + section anchor, e.g.
                      "signatures.html#cdex-signatures". Anchor is the nearest
                      preceding heading (honoring kramdown {#id}, otherwise a
                      GitHub-style slug). Used as the Context link target.
  - category          (added) Page/section topic the requirement belongs to,
                      e.g. "Signatures". This is the filter key for the
                      include.
  - actor             (inherited) Actor(s) the requirement constrains, e.g.
                      "Data Source", "Data Consumer", "Payer". MAY be a
                      comma-separated list (e.g. "Data Source,Data Consumer"),
                      in which case the requirement appears in every listed
                      actor's table.
  - isConditional     (added) "TRUE" when the rule is guarded by
                      if/when/unless/where/etc. Not rendered by default.
  - conformance       (inherited) Conformance verb: SHALL, SHALL-NOT, SHOULD,
                      SHOULD-NOT, MAY (DEPRECATED rows are filtered out and not
                      published). Multiple verbs, if ever present, use the
                      "<CONF>|<CONF>" form.
  - conformance_score (added) Numeric sort key for the verb
                      (SHALL=1, SHALL-NOT=2, SHOULD=3, SHOULD-NOT=4, MAY=5).
                      Rows are sorted by this so SHALLs lead each table.
  - requirement       (inherited) The requirement statement, a direct quote
                      from the IG, stored as Markdown. May include clarifying
                      context in square brackets.
  - comment           (added) Free-text reviewer/editor note. Not rendered.

The CSV is UTF-8 with every field quoted (RFC 4180). It is updated manually
when narrative requirements change, and also feeds the Requirements Resources.
================================================================== -->

{%- assign data_key = include.data | default: "conformance-cdex" -%}
{%- assign rows = site.data[data_key] -%}

{%- comment -%} Filter to this category, drop deprecated/blank, sort by score {%- endcomment -%}
{%- assign cat_rows = rows
      | where: "category", include.category
      | where_exp: "i", "i.conformance != 'DEPRECATED'"
      | where_exp: "i", "i.key != blank"
      | sort: "conformance_score" -%}

{%- comment -%} Resolve the actor list: explicit override, else derive + sort {%- endcomment -%}
{%- if include.actors -%}
  {%- assign actors = include.actors | split: "," -%}
{%- else -%}
  {%- comment -%} Flatten every (possibly comma-separated) actor cell, dedupe, sort.
       Normalize ", " to "," first so split yields clean tokens; any empty
       token from a trailing separator simply produces no table below. {%- endcomment -%}
  {%- assign actor_csv = "" -%}
  {%- for item in cat_rows -%}
    {%- assign actor_csv = actor_csv | append: item.actor | append: "," -%}
  {%- endfor -%}
  {%- assign actor_csv = actor_csv | replace: ", ", "," -%}
  {%- assign actors = actor_csv | split: "," | uniq | sort -%}
{%- endif -%}

{%- assign h = include.heading | default: "####" -%}

This section lists all narrative conformance statements in the {{ include.category }} section of this IG. The tables offer a concise summary for implementers to identify essential requirements and support evaluation and testing. The data is also available as [CSV] and [Excel] files, as well as in [CDex Requirements Resources].

{%- if include.legend -%}
**Legend:**

* **Key:** An identifier for the requirement.
* **Context:** The name and link to the narrative section that pertains to the requirement.
* **Conformance:** The conformance verb of the requirement: **SHALL**, **SHOULD**, **MAY**, **SHALL-NOT**, or **SHOULD-NOT**.
* **Requirement:** The actual requirements statement, which is a direct quote from the IG and may include helpful context in square brackets. Statements that contain multiple requirements in a single context are split into individual requirement statements.

{% endif -%}

{%- for actor in actors -%}
  {%- assign actor = actor | strip -%}

  {%- comment -%} Count matches first so empty actor tables are skipped {%- endcomment -%}
  {%- assign match_count = 0 -%}
  {%- for item in cat_rows -%}
    {%- assign item_actors = item.actor | split: "," -%}
    {%- for a in item_actors -%}
      {%- assign a = a | strip -%}
      {%- if a == actor -%}{%- assign match_count = match_count | plus: 1 -%}{%- endif -%}
    {%- endfor -%}
  {%- endfor -%}

  {%- if match_count > 0 %}
{{ h }} {{ actor }} Requirements
<table class="grid">
<thead>
  <tr>
    <th>Key</th>
    <th>Context</th>
    <th>Conformance</th>
    <th>Requirement</th>
  </tr>
</thead>
<tbody>
    {%- for item in cat_rows -%}
      {%- assign item_actors = item.actor | split: "," -%}
      {%- assign match = false -%}
      {%- for a in item_actors -%}
        {%- assign a = a | strip -%}
        {%- if a == actor -%}{%- assign match = true -%}{%- endif -%}
      {%- endfor -%}
      {%- if match -%}
        {%- assign ref_parts = item.reference | split: "#" -%}
        {%- if ref_parts[1] -%}
          {%- assign ctx_label = ref_parts[1] | replace: "-", " " -%}
        {%- else -%}
          {%- assign ctx_label = ref_parts[0] -%}
        {%- endif %}
  <tr id="{{ item.key }}"{% if item.Is_New == "TRUE" %} class="bg-success"{% endif %}>
    <td>{{ item.key }}</td>
    <td><a href="{{ item.reference }}">{{ ctx_label | strip }}</a></td>
    <td><strong>{{ item.conformance }}</strong></td>
    <td>{{ item.requirement | markdownify }}</td>
  </tr>
      {%- endif -%}
    {%- endfor %}
</tbody>
</table>
  {% endif -%}
{%- endfor -%}

{% include link-list.md %}