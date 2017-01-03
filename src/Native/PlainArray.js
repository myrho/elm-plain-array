//import Native.List //

var _user$project$Native_PlainArray = function() {

function empty_(table) {
  return {
    table : table || []
  }
}

function get(i, array)
{
	if (i < 0 || i >= length(array))
	{
		throw new Error(
			'Index ' + i + ' is out of range. Check the length of ' +
			'your array first or use getMaybe or getWithDefault.');
	}
	return unsafeGet(i, array);
}


function unsafeGet(i, array)
{
	return array.table[i];
}


// Sets the value at the index i. Only the nodes leading to i will get
// copied and updated.
function set(i, item, array)
{
	if (i < 0 || length(array) <= i)
	{
		return array;
	}
	return unsafeSet(i, item, array);
}


function unsafeSet(i, item, array)
{
  array.table[i] = item;
  return array;
}


function initialize(len, f)
{
	if (len <= 0)
	{
    return empty_();
	}

  var table = new Array(len);
  for (var i = 0; i < table.length; i++)
  {
    table[i] = f(i);
  }
  return {
    table: table
  };
}


function fromList(list)
{
	if (list.ctor === '[]')
	{
    return empty_();
	}

	// Allocate M sized blocks (table) and write list elements to it.
	var table = new Array();
	var nodes = [];
	var i = 0;

	while (list.ctor !== '[]')
	{
		table[i] = list._0;
		list = list._1;
		i++;

	}

  return {
    table: table
  };

}


// Pushes an item via js push
function push(item, a)
{
  a.table.push(item);
  return a;
}

// Converts an array into a list of elements.
function toList(a)
{
	return toList_(_elm_lang$core$Native_List.Nil, a);
}

function toList_(list, a)
{
	for (var i = a.table.length - 1; i >= 0; i--)
	{
		list =
				_elm_lang$core$Native_List.Cons(a.table[i], list)
	}
	return list;
}

// Maps a function over the elements of an array.
function map(f, a)
{
	var newA = {
		table: new Array(a.table.length)
	};
	for (var i = 0; i < a.table.length; i++)
	{
		newA.table[i] =
				f(a.table[i])
	}
	return newA;
}

// Maps a function over the elements with their index as first argument.
function indexedMap(f, a)
{
	var newA = {
		table: new Array(a.table.length)
	};
	for (var i = 0; i < a.table.length; i++)
	{
		newA.table[i] =
				A2(f, i, a.table[i])
	}
	return newA;
}

function foldl(f, b, a)
{
  for (var i = 0; i < a.table.length; i++)
  {
    b = A2(f, a.table[i], b);
  }
	return b;
}

function foldr(f, b, a)
{
  for (var i = a.table.length; i--; )
  {
    b = A2(f, a.table[i], b);
  }
	return b;
}

// TODO: currently, it slices the right, then the left. This can be
// optimized.
function slice(from, to, a)
{
		var newA = { };
    newA.table = a.table.slice(from, to);
    return newA;
}

// Appends two trees.
function append(a,b)
{
	if (a.table.length === 0)
	{
		return b;
	}
	if (b.table.length === 0)
	{
		return a;
	}

		var newA = { };
    newA.table = a.table.concat(b.table);
    return newA;
}

// Returns how many items are in the tree.
function length(array)
{
  return array.table.length;
}

function toJSArray(array)
{
  return array.table;
}

function fromJSArray(jsArray)
{
  if (jsArray.length === 0)
    {
      return empty_();
    }
  return { 
    table: jsArray
  }
}

return {
	fromList: fromList,
	toList: toList,
	initialize: F2(initialize),
	append: F2(append),
	push: F2(push),
	slice: F3(slice),
	get: F2(get),
	set: F3(set),
	map: F2(map),
	indexedMap: F2(indexedMap),
	foldl: F3(foldl),
	foldr: F3(foldr),
	length: length,

  toJSArray: toJSArray,
  fromJSArray: fromJSArray

};

}();
