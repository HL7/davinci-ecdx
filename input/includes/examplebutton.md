{% assign target = include.example | split: "." | first %}
{% assign file_type = include.example | split: "." | last %}
<p>
  <button class="btn btn-info btn-lg btn-block" type="button" title="Click to Open or Close Example" data-toggle="collapse" data-target="#{{target}}" aria-expanded="false" aria-controls="collapseExample">
    {{include.b_title | default: "Example" }}
  </button>
</p>

<div class="collapse" id="{{target}}" >
  <div class="card card-body" markdown="1">

{%raw%}
    {% if file_type == "html" %}
      {% include {{include.example}} %}
    {% else %}
      {% capture my-include %}{% include {{include.example}} %}{% endcapture %}{{ my-include | markdownify }}
    {% endif %}
{% endraw%}


{% include {{include.example}} %}


</div>
</div>
<br />