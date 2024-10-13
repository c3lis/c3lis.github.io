---
layout: page
title: archivve
---

 <div style="padding-top: 0px;">
	<div style="background-color: #15171a; ">
<section>

  {% if site.posts[0] %}

    {% capture currentyear %}{{ 'now' | date: "%Y" }}{% endcapture %}
    {% capture firstpostyear %}{{ site.posts[0].date | date: "<font color='gray'>un post ma' mi gente pa' toos' ustedes!</font>" }}{% endcapture %}
    {% if currentyear == firstpostyear %}
         <h3>{{ firstpostyear }}</h3>

    {% else %}
        <h3>{{ firstpostyear }}</h3>
    {% endif %}
<p><font color="red" style="text-shadow: 0px 0px 10px white;" >c3lis</font></p>
<!-- <pre font color="white" style='font-size: 11.5px;' >
    <span class="cuadro1"></span> Difícil. <span class="cuadro2"></span> Medio. <span class="cuadro3"></span> Fácil.   
</pre>
!-->
    {%for post in site.posts %}
      {% unless post.next %}
        <ul>
      {% else %}
        {% capture year %}{{ post.date | date: '%Y' }}{% endcapture %}
        {% capture nyear %}{{ post.next.date | date: '%Y' }}{% endcapture %}
        {% if year != nyear %}
          </ul>

          <h3>{{ post.date | date: ' ' }}</h3>
          <ul>
        {% endif %}
      {% endunless %}
        <li><time>{{ post.date | date:" " }}  </time>
          <a href="{{ post.url | prepend: site.baseurl | replace: '//', '/' }}">
            {{ post.title }}
          </a>
        </li>
    {% endfor %}
    </ul>


  {% endif %}
</section>
</div>
