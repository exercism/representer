
              

object BinarySearch {

    def find(ls:List[Int], target:Int): Option[Int] = {
      def subfind(l:Int,r:Int): Option[Int] = {
        if (l > r) None
        else {
          val m = (l + r) / 2
          ls(m) match{
            case x if ls(m) == target => Some(m)
            case x if ls(m) > target =>subfind(l,m - 1)
            case x if ls(m) < target =>subfind(m+1,r)
            

            
          }
        }
      }
    subfind(0,ls.size - 1)

    }
}