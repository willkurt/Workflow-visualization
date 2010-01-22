
class ActivityNode
{
  PFont font;
  String name;
  int textW;
  int x;
  int y;

  int h;
  int w;

  public ActivityNode(String name,int x, int y)
  {
    this.font = createFont("Helvetica",18);
    this.x = x;
    this.y = y;
    this.name = name;
    textFont(font);
    this.w = (int)textWidth(name)+10;
    this.h = (int)textWidth('W');
  }

  public void display()
  {
    fill(255);
    // stroke(0);
    // rect(x,y,w,h);
    fill(0);
    textFont(font);
    text(name,x,y+h);
  }

  public void connect(ActivityNode n,int times)
  {
    //NOTE the length of the beziers must be proportional to the distance the objects are from each other

    //if the node is below me connect on the right,
    //other wise connect on the left
    int strokeShade;
    int i;
    if(n.y > this.y)//node below
    {
      noFill();
      i = 0;
      while(i<times){
        strokeShade = (int)random(70,170);
        stroke(strokeShade,strokeShade,strokeShade,random(120,200));
        bezier(random(this.x-14,this.x+2),random(this.y,this.y+this.h),this.x-random(20,100)-((n.y-this.y)/4),random(this.y,this.y+this.h),
        n.x-random(20,100)-((n.y-this.y)/4),random(n.y,n.y+n.h),random(n.x-14,this.x+2),random(n.y,n.y+n.h));
        i++;
      }
    }
    else
    {
      noFill();
      // bezier(this.x+this.w,this.y,this.x+this.w+20,this.y,n.x+n.w+20,n.y,n.x+n.w,n.y);
      i = 0;
      while(i<times){
        strokeShade = (int)random(70,170);
        stroke(strokeShade,strokeShade,strokeShade,random(70,200));
        bezier(random(this.x+this.w-8,this.x+this.w+8),random(this.y,this.y+this.h),this.x+this.w+random(20,100)+(abs((n.y-this.y))/4),random(this.y,this.y+this.h),
        n.x+n.w+random(20,100)+((abs(n.y-this.y))/4),random(n.y,n.y+n.h),random(n.x+n.w-8,n.x+n.w+8),random(n.y,n.y+n.h));
        i++;
      }
    }

  }

}



