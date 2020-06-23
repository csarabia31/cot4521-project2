

class Polygon {
  
   ArrayList<Point> p     = new ArrayList<Point>();
   ArrayList<Edge>  bdry = new ArrayList<Edge>();
     
   Polygon( ){  }
   
   
   boolean isClosed(){ return p.size()>=3; }
   
   
   boolean isSimple(){
     // TODO: Check the boundary to see if it is simple or not.
     ArrayList<Edge> bdry = getBoundary();
     for(int i = 0; i<bdry.size(); i++)
     {
            for(int j=0;j<bdry.size();j++)
           {
              if(i==j)
                continue;
                
              if(isAdjacent(bdry.get(i), bdry.get(j)) == true)
                continue;
        
              if(bdry.get(i).intersectionTest( bdry.get(j)) == true)
                  return false;
      
           }
       
       
     }
     
     return true;
}

   boolean isAdjacent(Edge one, Edge two)
   {
      if((one.p0.p.x == two.p0.p.x && one.p0.p.y == two.p0.p.y) || (one.p0.p.x == two.p1.p.x && one.p0.p.y == two.p1.p.y) ||
         (one.p1.p.x == two.p0.p.x && one.p1.p.y == two.p0.p.y) || (one.p1.p.x == two.p1.p.x && one.p1.p.y == two.p1.p.y))
               return true;
               
      return false; 
   }

   boolean intersect (Edge one, Edge two){
     
     
          
           //starting point 1
           float p0x = one.p0.p.x;
           float p0y = one.p0.p.y;
     
           //ending point 1
           float p1x = one.p1.p.x - one.p0.p.x;
           float p1y = one.p1.p.y - one.p0.p.y;
     
           //starting point 2
           float otherp0x = two.p0.p.x;
           float otherp0y = two.p0.p.y;
     
           //ending point 2
           float otherp1x = two.p1.p.x - two.p0.p.x;
           float otherp1y = two.p1.p.y - two.p0.p.y;
     
     
           //solving for t
     
           float t = (otherp1x * (p0y-otherp0y) + otherp1y * (otherp0x-p0x)) / (p1x * otherp1y - p1y*otherp1x);
           //getting intersection point
     
           
     
     
     
     
          if(t>=0 && t<=1)
              return true;
                    
        
       
     
     return false;
   }
 
   
   
   boolean pointInPolygon( Point p ){
     // TODO: Check if the point p is inside of the
     Point r = new Point(p.p.x * 1000, p.p.y);
     int count = 0;
     
     Edge ray = new Edge(p, r);
     ArrayList<Edge> bdry = getBoundary();
     for(int i = 0; i < bdry.size(); i++)
     {
         if(ray.intersectionTest(bdry.get(i)) == true  && (ray.intersectionPoint(bdry.get(i)) != bdry.get(i).p0 || ray.intersectionPoint(bdry.get(i)) != bdry.get(i).p1))
             count++;
     }
     if(count%2==1)
       return true;
       
     return false;
   }
   
   
   ArrayList<Edge> getDiagonals(){
     // TODO: Determine which of the potential diagonals are actually diagonals
     ArrayList<Edge> bdry = getBoundary();
     ArrayList<Edge> diag = getPotentialDiagonals();
     ArrayList<Edge> ret  = new ArrayList<Edge>();

     for(int i=0; i< diag.size(); i++)
     {
       
      int count = 0;
      for(int j = 0;j<bdry.size();j++)
      {
         //if(pointInPolygon(diag.get(i).midpoint())==false)
                 //break;
         if(!isAdjacent(diag.get(i),bdry.get(j)) )
         {
           if(diag.get(i).intersectionTest(bdry.get(j))==true) 
                 count++;
          
         }
         
      }
      if(count>0)
        continue;
      else if (pointInPolygon(diag.get(i).midpoint())==false)
                 continue;
      else ret.add(diag.get(i));
         
      //println(count);
      
     }
     return ret;
   }
   
   
   boolean ccw(){
     // TODO: Determine if the polygon is oriented in a counterclockwise fashion
      if( !isClosed() ) return false;
     if( !isSimple() ) return false;
     float sum = 0;
     float result = 0;
     ArrayList<Edge> bdry = getBoundary();
     for(int i = 0; i<bdry.size();i++)
     {
       Edge temp = bdry.get(i);
       result = (temp.p1.p.x - temp.p0.p.x) * (temp.p1.p.y + temp.p0.p.y);
       sum += result;
       
     }
     if(sum < 0)
       return true;
       
     return false;
     
     
   }
   
   
   boolean cw(){
     // TODO: Determine if the polygon is oriented in a clockwise fashion
     if( !isClosed() ) return false;
     if( !isSimple() ) return false;
     float sum = 0;
     float result = 0;
     ArrayList<Edge> bdry = getBoundary();
     for(int i = 0; i<bdry.size();i++)
     {
       Edge temp = bdry.get(i);
       result = (temp.p1.p.x - temp.p0.p.x) * (temp.p1.p.y + temp.p0.p.y);
       sum += result;
       
     }
     if(sum >= 0)
       return true;
       
     return false;
   }
      
   
   
   
   ArrayList<Edge> getBoundary(){
     return bdry;
   }


   ArrayList<Edge> getPotentialDiagonals(){
     ArrayList<Edge> ret = new ArrayList<Edge>();
     int N = p.size();
     for(int i = 0; i < N; i++ ){
       int M = (i==0)?(N-1):(N);
       for(int j = i+2; j < M; j++ ){
         ret.add( new Edge( p.get(i), p.get(j) ) );
       }
     }
     return ret;
   }
   

   void draw(){
     //println( bdry.size() );
     for( Edge e : bdry ){
       e.draw();
     }
   }
   
   
   void addPoint( Point _p ){ 
     p.add( _p );
     if( p.size() == 2 ){
       bdry.add( new Edge( p.get(0), p.get(1) ) );
       bdry.add( new Edge( p.get(1), p.get(0) ) );
     }
     if( p.size() > 2 ){
       bdry.set( bdry.size()-1, new Edge( p.get(p.size()-2), p.get(p.size()-1) ) );
       bdry.add( new Edge( p.get(p.size()-1), p.get(0) ) );
     }
   }

}
