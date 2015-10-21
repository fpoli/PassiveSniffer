function get_cell_data() {
  var matrix = [];  
  $("tr").each(function(i) {
    var $cells_in_row = $("td", this);
    // If doesn't exist, create array for row
    if(!matrix[i]) matrix[i] = [];
    $cells_in_row.each(function(j) {
      // CALCULATE VISUAL COLUMN
      // Store progress in matrix
      var column = next_column(matrix[i]);
      // Store it in data to use later
      $(this).data("column", column);
      // Consume this space
      matrix[i][column] = "x";
      // If the cell has a rowspan, consume space across
      // Other rows by iterating down
      if($(this).attr("rowspan")) {
        // Store rowspan in data, so it's not lost
        var rowspan = parseInt($(this).attr("rowspan"));
        $(this).data("rowspan", rowspan);
        for(var x = 1; x < rowspan; x++) {
          // If this row doesn't yet exist, create it
          if(!matrix[i+x]) matrix[i+x] = [];
          matrix[i+x][column] = "x";
        }
      }
    });
  });
  
  // Calculate the next empty column in our array
  // Note that our array will be sparse at times, and
  // so we need to fill the first empty index or push to end
  function next_column(ar) {
    for(var next = 0; next < ar.length; next ++) {
      if(!ar[next]) return next;
    }
    return next;
  }
}

function calculate_rowspans() {
  // Remove all temporary cells
  $(".tmp").remove();
  
  // We don't care about the last row
  // If it's hidden, it's cells can't go anywhere else
  $("tr").not(":last").each(function() {
    var $tr = $(this);
    
    // Iterate over all non-tmp cells with a rowspan    
    $("td[rowspan]:not(.tmp)", $tr).each(function() {
      $td = $(this);
      var $rows_down = $tr;
      var new_rowspan = 1;
      
      // If the cell is visible then we don't need to create a copy
      if($td.is(":visible")) {
        // Traverse down the table given the rowspan
        for(var i = 0; i < $td.data("rowspan") - 1; i ++) {
          
          $rows_down = $rows_down.next();
          // If our cell's row is visible then it can have a rowspan
          if($rows_down.is(":visible")) {
            new_rowspan ++;
          }
        }
        // Set our rowspan value
        $td.attr("rowspan", new_rowspan);   
      }
      else {
        // We'll normally create a copy, unless all of the rows
        // that the cell would cover are hidden
        var $copy = false;
        // Iterate down over all rows the cell would normally cover
        for(var i = 0; i < $td.data("rowspan") - 1; i ++) {
          $rows_down = $rows_down.next();
          // We only consider visible rows
          if($rows_down.is(":visible")) {
            // If first visible row, create a copy
            if(!$copy) {
              $copy = $td.clone(true).addClass("tmp");
              // You could do this 1000 better ways, using classes e.g
              $copy.css({
                "background-color": $td.parent().css("background-color")
              });
              // Insert the copy where the original would normally be
              // by positioning it relative to it's columns data value 
              var $before = $("td", $rows_down).filter(function() {
                return $(this).data("column") > $copy.data("column");
              });
              if($before.length) $before.eq(0).before($copy);
              else $(".delete-cell", $rows_down).before($copy);
            }
            // For all other visible rows, increment the rowspan
            else new_rowspan ++;
          }
        }
        // If we made a copy then set the rowspan value
        if($copy) $copy.attr("rowspan", new_rowspan);
      }
    });
  });
}
