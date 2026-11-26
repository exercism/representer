/**
* Your implmentation of the ScrabbleScore exercise
*/
component {
	
	/**
	* @returns 
	*/
	 function score( word ) {
		word = lCase(word);
		ans = 0;
		one = ['a','e','i','o','u','l','n','r','s','t'];
		two = ['d','g'];
		three = ['b','c','m','p'];
		four = ['f','h','v','w','y'];
		five = ['k'];
		eight = ['j','x'];
		ten = ['q','z'];
		for (i=1;i<=Len(word);i++) {
			if (ArrayFind(one, word[i])!=0) ans++;
			else if (ArrayFind(two, word[i])!=0) ans += 2;
			else if (ArrayFind(three, word[i])!=0) ans += 3;
			else if (ArrayFind(four, word[i])!=0) ans += 4;
			else if (ArrayFind(five, word[i])!=0) ans += 5;
			else if (ArrayFind(eight, word[i])!=0) ans += 8;
			else if (ArrayFind(ten, word[i])!=0) ans += 10;
		}
		return ans;
	}
	
}