$(document).ready(function(){
  $('#mapdata').on('input',calc);
  $('#domination').change(calc);
  $('#ambush').change(calc);
  $('#z-none').change(calc);
  $('#zana').change(calc);
  $('#fragments').change(calc);
});

function calc(){
    var str = $('#mapdata').val();
    var zana = Math.min(Number($('#zana').val()),8);
    zana= Math.max(0,zana);
    
    var fragments = Math.min(Number($('#fragments').val()),3);
    fragments = Math.max(0,fragments);
    
    var base = 1.75;
    
    var q = getVal( str.match(/(Quantity:)\s\+([0-9]*)/),2,0);
    q += zana;
    q += fragments * 5;
    
    var p = getVal( str.match(/(Pack\sSize.*:)\s\+([0-9]*)/),2,0);
    var m = getVal( str.match(/(\d\d)%\smore\sMagic/),1,0);
    var r = getVal( str.match(/(\d\d)%\smore\sRare/),1,0);
    var z = 1;
    if($('#domination').prop('checked')){
      // map contains ~50 packs, 5 shrines of 3 packs each = 15, 15/50 = 30%
      z = 1.3;
    }
    else if($('#ambush').prop('checked')){
      // map contains ~50 packs, 4 boxes of 3 packs each = 12, 12/50 = 24%
      z = 1.24;
    }
    
    q = q/100 + 1;
    // * 2 on pack size because of how circles work
    p = (p*2)/100 + 1;
    // 15% of monsters are magic, drop 4x amount of items
    m = m*.15*4/100 + 1; 
    // 3% of monsters are rare, drop 8x amount of items
    r = r*.03*8/100 + 1;
    
    console.log(q,p,m,r,z);
    
    var maps = (base * q * p * m * z) + (base * q * (r - 1) );
    var result = Math.round(maps * 100) / 100;
    
    $('#result').text(result);
}

function getVal(arr,index,def){
  var rv = def;
  if(arr){
    rv = Number(arr[index])
  }
  return rv;
}