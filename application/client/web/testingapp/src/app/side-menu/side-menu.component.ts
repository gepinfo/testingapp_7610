import { Component, OnInit,EventEmitter, Input, Output } from '@angular/core';
import { Router } from '@angular/router';

@Component({
  selector: 'app-side-menu',
  templateUrl: './side-menu.component.html',
  styleUrls: ['./side-menu.component.scss']
})
export class SideMenuComponent implements OnInit {
  isActive: boolean =  true;
  isCollapsed: boolean = false;
  // isExpanded: boolean = true;
  panelOpenState = false;
  loginService: any;
  
    constructor(public route:Router){
  
    }

    toggleMenu() {
      this.isCollapsed = !this.isCollapsed;
      this.isExpanded = !this.isExpanded;
    }

    accordionItems = [
      { header: 'Item 1', content: 'Content for Item 1' },
      { header: 'Item 2', content: 'Content for Item 2' },
      { header: 'Item 3', content: 'Content for Item 3' }
    ];
  
    selectedIndex: number | null = null;
  
    toggleAccordion(index: number): void {
      if (this.selectedIndex === index) {
        this.selectedIndex = null;
      } else {
        this.selectedIndex = index;
      }
    }
  
  ngOnInit(): void {
    this.checkScreenWidth();
  }
  
  checkScreenWidth(): void {
    this.isExpanded = window.innerWidth > 750;
  }

  @Input() isExpanded: boolean = false;
  @Output() toggleSidebar: EventEmitter<boolean> = new EventEmitter<boolean>();

  handleSidebarToggle = () => this.toggleSidebar.emit(!this.isExpanded);
  
  
  setCurrentMenu(menu: string) {
    // Implement logic to handle the current menu selection
  }

  authArray:any;
  public isAdminUser = true;
  public userId: string | null | undefined = '';

  logout() {
		this.authArray = [];
			 
		const temp = {
			 id: sessionStorage.getItem('Id')
		};
		this.loginService.Logout(temp).subscribe(data => {
			sessionStorage.clear();
		this.userId = sessionStorage.getItem('Id') || null;
		this.route.navigate(['']);
		}, error => {
			console.error('error:', error);
		});
		}
  
  
  
  usersComp(){
    this.route.navigate(['sefscreen']);
  }
    
  settingComp(){
    this.route.navigate(['setting']);
  }
  
}
