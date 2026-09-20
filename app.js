const books=[
["Genesis",50],["Exodus",40],["Leviticus",27],["Numbers",36],["Deuteronomy",34],["Joshua",24],["Judges",21],["Ruth",4],
["1 Samuel",31],["2 Samuel",24],["1 Kings",22],["2 Kings",25],["1 Chronicles",29],["2 Chronicles",36],["Ezra",10],["Nehemiah",13],["Esther",10],["Job",42],
["Psalms",150],["Proverbs",31],["Ecclesiastes",12],["Song of Solomon",8],["Isaiah",66],["Jeremiah",52],["Lamentations",5],["Ezekiel",48],["Daniel",12],
["Hosea",14],["Joel",3],["Amos",9],["Obadiah",1],["Jonah",4],["Micah",7],["Nahum",3],["Habakkuk",3],["Zephaniah",3],["Haggai",2],["Zechariah",14],["Malachi",4],
["Matthew",28],["Mark",16],["Luke",24],["John",21],["Acts",28],["Romans",16],["1 Corinthians",16],["2 Corinthians",13],["Galatians",6],["Ephesians",6],
["Philippians",4],["Colossians",4],["1 Thessalonians",5],["2 Thessalonians",3],["1 Timothy",6],["2 Timothy",4],["Titus",3],["Philemon",1],
["Hebrews",13],["James",5],["1 Peter",5],["2 Peter",3],["1 John",5],["2 John",1],["3 John",1],["Jude",1],["Revelation",22]
];
const motivations=[
"God has a plan for you. Keep going.","You are never alone. God is with you.",
"Pray about it. Trust God with it. Keep moving.","Your hard season does not last forever.",
"God's timing is worth trusting.","You don't have to have everything figured out today.",
"Keep your eyes on God, not your problems."
];
const studies=[
["Getting Closer to God","Build a stronger daily relationship with God.","♥",7],
["Faith When Life Is Hard","Verses for courage, hope, and perseverance.","⛰",7],
["Who God Says You Are","Discover your identity through Scripture.","✦",5]
];

const main=document.getElementById("main"), title=document.getElementById("pageTitle");
let current="home", historyStack=[];

function setPage(page){
 current=page; historyStack=[]; title.textContent={home:"Home",bible:"Bible",study:"Bible Study",motivation:"Motivation"}[page];
 document.querySelectorAll(".tabbar button").forEach(b=>b.classList.toggle("active",b.dataset.page===page));
 ({home:renderHome,bible:renderBible,study:renderStudy,motivation:renderMotivation}[page])();
}
document.querySelectorAll(".tabbar button").forEach(b=>b.onclick=()=>setPage(b.dataset.page));
document.getElementById("themeBtn").onclick=()=>{document.body.classList.toggle("dark");localStorage.theme=document.body.classList.contains("dark")?"dark":"light"};
if(localStorage.theme==="dark")document.body.classList.add("dark");

function renderHome(){
 const day=new Date().getDate();
 main.innerHTML=`
 <section class="card hero">
  <div class="label">VERSE OF THE DAY</div>
  <div class="verse">“I can do all things through Christ which strengtheneth me.”</div>
  <div class="muted">Philippians 4:13 — KJV</div>
 </section>
 <section class="card"><div class="label">TODAY'S MOTIVATION</div><p class="quote">${motivations[day%motivations.length]}</p><p class="muted">God loves you, and you don't have to walk through life alone.</p></section>
 <div class="sectionTitle">Quick Start</div>
 <div class="grid">
  <button class="quick" onclick="setPage('bible')">📖<b>Read the Bible</b><small>All 66 books</small></button>
  <button class="quick" onclick="setPage('study')">✦<b>Bible Study</b><small>Build your faith</small></button>
  <button class="quick" onclick="setPage('motivation')">⚡<b>Motivation</b><small>Keep going</small></button>
  <button class="quick" onclick="alert('Prayer feature coming next!')">🙏<b>Prayer</b><small>Talk to God</small></button>
 </div>
 <div class="sectionTitle">A reminder</div>
 <section class="card"><b>God has a future for you.</b><p class="muted">Take today one step at a time. Pray, read, and keep moving forward.</p></section>`;
}

function renderBible(){
 main.innerHTML=`
 <input id="bookSearch" class="search" placeholder="Search Bible books">
 <div id="bookList"></div>`;
 const input=document.getElementById("bookSearch"), list=document.getElementById("bookList");
 function draw(){
   const q=input.value.toLowerCase();
   list.innerHTML=books.filter(b=>b[0].toLowerCase().includes(q)).map(b=>
    `<button class="book" onclick="showChapters('${b[0].replace(/'/g,"\\'")}',${b[1]})"><b>📖 ${b[0]}</b><span>${b[1]} chapters ›</span></button>`).join("");
 }
 input.oninput=draw;draw();
}
function showChapters(book,count){
 historyStack.push("bible");
 title.textContent=book;
 main.innerHTML=`<button class="back" onclick="goBack()">‹ All Books</button><div class="sectionTitle">Choose a chapter</div><div class="chapterGrid">${Array.from({length:count},(_,i)=>`<button class="chapterBtn" onclick="loadChapter('${book.replace(/'/g,"\\'")}',${i+1})">${i+1}</button>`).join("")}</div>`;
}
function goBack(){setPage(historyStack.pop()||"bible")}
async function loadChapter(book,chapter){
 historyStack.push("bible");
 title.textContent=`${book} ${chapter}`;
 main.innerHTML=`<button class="back" onclick="showChapters('${book.replace(/'/g,"\\'")}',${books.find(b=>b[0]===book)[1]})">‹ Chapters</button><section class="card"><p class="muted">Loading Scripture…</p></section>`;
 try{
  const url=`https://bible-api.com/${encodeURIComponent(book+" "+chapter)}?translation=kjv`;
  const r=await fetch(url); if(!r.ok)throw Error();
  const data=await r.json();
  main.innerHTML=`<button class="back" onclick="showChapters('${book.replace(/'/g,"\\'")}',${books.find(b=>b[0]===book)[1]})">‹ Chapters</button>
  <div class="sectionTitle">${data.reference}</div>
  <section class="card">${data.verses.map(v=>`<div class="verseRow"><span class="num">${v.verse}</span><span>${v.text.trim()}</span></div>`).join("")}</section>`;
 }catch(e){main.innerHTML=`<button class="back" onclick="showChapters('${book.replace(/'/g,"\\'")}',${books.find(b=>b[0]===book)[1]})">‹ Chapters</button><section class="card"><b>Couldn't load this chapter.</b><p class="muted">Check your internet connection and try again.</p></section>`}
}
function renderStudy(){
 main.innerHTML=studies.map(s=>`<button class="book" onclick="showStudy('${s[0].replace(/'/g,"\\'")}',${s[3]})"><span class="plan"><span class="planIcon">${s[2]}</span><span><b>${s[0]}</b><br><small>${s[1]}</small></span></span><span>›</span></button>`).join("");
}
function showStudy(name,days){
 title.textContent=name;
 main.innerHTML=`<button class="back" onclick="setPage('study')">‹ Study Plans</button><section class="card"><h2>${name}</h2><p class="muted">A simple plan to help you spend time with God each day.</p></section>`+
 Array.from({length:days},(_,i)=>`<section class="card day"><b>Day ${i+1}</b><p class="muted">Read Scripture, pray, and write down one thing God is teaching you.</p></section>`).join("");
}
function renderMotivation(){
 main.innerHTML=motivations.map((m,i)=>`<section class="card"><div class="label">MESSAGE ${i+1}</div><p class="quote">${m}</p></section>`).join("");
}
setPage("home");

if("serviceWorker" in navigator) navigator.serviceWorker.register("sw.js").catch(()=>{});
