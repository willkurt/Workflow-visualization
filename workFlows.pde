import processing.pdf.*;



FileProcessor fp = new FileProcessor("/Users/will/Documents/Processing/workFlows/data/data.txt");
HashMap taskConnectMap = fp.getTaskConnectMap();
HashMap objectLookup;
ActivityNode[] anodes = new ActivityNode[]{
};
PFont titleFont;


void setup()
{
  //String[] fontList = PFont.list();
  //println(fontList);
  smooth();
  objectLookup = buildObjectLookupMap(taskConnectMap,50,500,50);
  anodes = (ActivityNode[])objectLookup.values().toArray(anodes);
  size(1200,2700);


  beginRecord(PDF, "septILL.pdf");


  titleFont = createFont("TrebuchetMS",22);

}


void draw()
{

  background(255);
  textFont(titleFont);
  fill(30);
  text("ILL September by Will Kurt",100,20);

  //draw the nodes
  for(int i = 0;i<anodes.length;i++)
  {
    anodes[i].display();
  }

  //draw the connection

  drawConnections();







  endRecord();
  noLoop();

}

HashMap buildObjectLookupMap(HashMap connectionMap,int distance,int xstart,int ystart)
{
  HashMap rmap = new HashMap();
  String[] keys = new String[]{
  };
  keys = (String[])connectionMap.keySet().toArray(keys);
  int x = xstart;
  int y = ystart;
  //make sure the draw startTokens first and endTokens last
  for(int i = 0;i<keys.length;i++)
  {
    if(fp.isStartToken(keys[i]))
    {
      println(i);
      rmap.put(keys[i],new ActivityNode(keys[i],x,y));
      y += distance;
    }
  }
  for(int i = 0;i<keys.length;i++)
  {
    if(!(fp.isStartToken(keys[i]) || fp.isEndToken(keys[i])))
    {
      println(i);
      rmap.put(keys[i],new ActivityNode(keys[i],x,y));
      y += distance;
    }
  }
  for(int i = 0;i<keys.length;i++)
  {
    if(fp.isEndToken(keys[i]))
    {
      println(i);
      rmap.put(keys[i],new ActivityNode(keys[i],x,y));
      y += distance;
    }
  }
  return rmap;
}

void drawConnections()
{
  for(int i = 0;i<anodes.length;i++)
  {
    HashMap connections = (HashMap)taskConnectMap.get(anodes[i].name);
    String[] keys = new String[]{
    };
    keys = (String[])connections.keySet().toArray(keys);//no good reason to do this each time...
    drawConnection(anodes[i],keys,connections);
  }
}


void drawConnection(ActivityNode anode,String[] keys, HashMap connections)
{
  for(int j=0;j<keys.length;j++)
  {
    if((Integer)connections.get(keys[j]) > new Integer(0))
    {
      //scaling it here
      int val = ((Integer)connections.get(keys[j])).intValue();
      /*if(val <= 10)
       {
       val = 1;
       }
       else
       {
       val = val/10;
       }
       */
      anode.connect((ActivityNode)objectLookup.get(keys[j]),val);
    }
  }
}




