// === DINO CHROME CHEAT GOD BOT VERSION ===
(function(){
  if (document.getElementById("dinoCheatMenu")) {
    alert("Cheat Menu sudah ada!");
    return;
  }

  // === Buat panel cheat UI ===
  let menu = document.createElement("div");
  menu.id = "dinoCheatMenu";
  menu.style.position = "fixed";
  menu.style.top = "20px";
  menu.style.right = "20px";
  menu.style.background = "rgba(0,0,0,0.85)";
  menu.style.color = "white";
  menu.style.padding = "15px";
  menu.style.borderRadius = "10px";
  menu.style.zIndex = "9999";
  menu.style.fontFamily = "Arial";
  menu.style.fontSize = "14px";
  menu.style.width = "240px";
  menu.style.boxShadow = "0 0 15px rgba(0,0,0,0.7)";
  menu.innerHTML = `
    <b>🦖 Dino Cheat</b><br><br>
    <button id="btnGod">🛡️ God Mode</button><br><br>
    <button id="btnSpeed">⚡ Speed x10</button><br><br>
    <button id="btnJump">🦘 Super Jump</button><br><br>
    <button id="btnScore">📊 +Skor 99999</button><br><br>
    <button id="btnAuto">🤖 Auto Jump</button><br><br>
    <button id="btnBot">🧠 Full Bot Mode</button><br><br>
    <button id="btnClose">❌ Tutup</button><br><br>
    <small>🎮 Speed pakai ⬅ ➡</small>
  `;
  document.body.appendChild(menu);

  // Styling tombol
  [...menu.querySelectorAll("button")].forEach(btn=>{
    btn.style.width = "100%";
    btn.style.margin = "3px 0";
    btn.style.padding = "6px";
    btn.style.border = "none";
    btn.style.borderRadius = "6px";
    btn.style.cursor = "pointer";
    btn.style.fontWeight = "bold";
  });

  // === Cheat Functions ===
  let god = false;
  let auto = false;
  let bot = false;
  let autoInterval, botInterval;
  let currentSpeed = 6; // default

  // God Mode
  document.getElementById("btnGod").onclick = ()=>{
    god = !god;
    if(god){
      Runner.instance_.gameOver = function(){};
      alert("🛡️ God Mode ON");
    } else {
      Runner.instance_.gameOver = Runner.prototype.gameOver;
      alert("🛡️ God Mode OFF");
    }
  };

  // Speed Boost
  document.getElementById("btnSpeed").onclick = ()=>{
    currentSpeed = 100;
    Runner.instance_.setSpeed(currentSpeed);
    alert("⚡ Speed x10 Aktif!");
  };

  // Super Jump
  document.getElementById("btnJump").onclick = ()=>{
    Runner.instance_.tRex.setJumpVelocity(50);
    alert("🦘 Super Jump Aktif!");
  };

  // Skor instan
  document.getElementById("btnScore").onclick = ()=>{
    Runner.instance_.distanceRan += 99999;
    alert("📊 Skor ditambah 99999!");
  };

  // Auto Jump (deteksi obstacle)
  document.getElementById("btnAuto").onclick = ()=>{
    auto = !auto;
    if(auto){
      alert("🤖 Auto Jump ON");
      autoInterval = setInterval(()=>{
        let tRex = Runner.instance_.tRex;
        let obstacles = Runner.instance_.horizon.obstacles;
        if (obstacles.length > 0){
          let obs = obstacles[0];
          let distance = obs.xPos - tRex.xPos;
          if (distance < 60 && !tRex.jumping){
            tRex.startJump(1);
          }
        }
      }, 10);
    } else {
      alert("🤖 Auto Jump OFF");
      clearInterval(autoInterval);
    }
  };

  // FULL BOT MODE (main sendiri + farming skor)
  document.getElementById("btnBot").onclick = ()=>{
    bot = !bot;
    if(bot){
      alert("🧠 Full Bot Mode ON (AFK farming aktif)");
      god = true; 
      Runner.instance_.gameOver = function(){}; // Auto God Mode
      botInterval = setInterval(()=>{
        Runner.instance_.tRex.startJump(1);
        Runner.instance_.distanceRan += 5; // skor auto nambah terus
      }, 100);
    } else {
      alert("🧠 Full Bot Mode OFF");
      clearInterval(botInterval);
    }
  };

  // Tutup menu
  document.getElementById("btnClose").onclick = ()=>{
    menu.remove();
    document.removeEventListener("keydown", keyControl);
    clearInterval(autoInterval);
    clearInterval(botInterval);
  };

  // Kontrol speed pakai keyboard (⬅ ➡)
  function keyControl(e){
    if (e.key === "ArrowRight"){ // tambah speed
      currentSpeed += 1;
      Runner.instance_.setSpeed(currentSpeed);
      console.log("⚡ Speed:", currentSpeed);
    }
    if (e.key === "ArrowLeft"){ // kurangi speed
      currentSpeed = Math.max(1, currentSpeed - 1);
      Runner.instance_.setSpeed(currentSpeed);
      console.log("🐢 Speed:", currentSpeed);
    }
  }
  document.addEventListener("keydown", keyControl);
})();
