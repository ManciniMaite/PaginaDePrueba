import { Component } from '@angular/core';
import { RouterOutlet } from '@angular/router';
import { Persona } from './model/Persona';
import { PersonaService } from './services/persona-service.service';
import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { FormsModule } from '@angular/forms'; 
import { CommonModule } from '@angular/common'; 
import { HttpClientModule } from '@angular/common/http';


@Component({
  selector: 'app-root',
  standalone: true,
  imports: [RouterOutlet,
    HttpClientModule,
    FormsModule,     
    CommonModule
  ],
  templateUrl: './app.component.html',
  styleUrl: './app.component.scss'
})
export class AppComponent {
  title = 'pruebaFront';

  personas: Persona[] = [];
  selectedPersona: Persona = new Persona();

  constructor(private personaService: PersonaService) { }

  ngOnInit(): void {
    this.getPersonas();
  }

  getPersonas(): void {
    this.personaService.getPersonas().subscribe(data => {
      this.personas = data;
    });
  }

  createPersona(): void {
    this.personaService.createPersona(this.selectedPersona).subscribe(() => {
      this.getPersonas();
      this.selectedPersona = new Persona(); // Limpiar el formulario
    });
  }

  updatePersona(): void {
    if (this.selectedPersona.id) {
      this.personaService.updatePersona(this.selectedPersona.id, this.selectedPersona).subscribe(() => {
        this.getPersonas();
        this.selectedPersona = new Persona(); // Limpiar el formulario
      });
    }
  }

  deletePersona(id: number): void {
    this.personaService.deletePersona(id).subscribe(() => {
      this.getPersonas();
    });
  }

  selectPersona(persona: Persona): void {
    this.selectedPersona = { ...persona };
  }
}
