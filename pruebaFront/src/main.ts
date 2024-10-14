import { bootstrapApplication } from '@angular/platform-browser';
import { appConfig } from './app/app.config';
import { AppComponent } from './app/app.component';
import { provideHttpClient } from '@angular/common/http';
import { provideRouter } from '@angular/router';


bootstrapApplication(AppComponent,{
  providers: [
    provideRouter([]),
    provideHttpClient() // Aquí se agrega el proveedor del HttpClient
  ],
}).catch(err => console.error(err));
