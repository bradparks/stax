package funk.collections.immutable;

import funk.collections.NilTestBase;
import funk.collections.immutable.Nil;

using funk.collections.immutable.Nil;

/**
* Auto generated MassiveUnit Test Class  for funk.collections.immutable.Nil 
*/
class NilTest extends NilTestBase {
	
	@Before
	public function setup():Void {
		actual = nil.list();
		expected = nil.list();
		other = nil.list();
	}
	
	@After
	public function tearDown():Void {
		actual = null;
		expected = null;
		other = null;
	}
}